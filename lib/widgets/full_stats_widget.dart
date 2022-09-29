import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/widgets/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Pages/home_page.dart';

class FullStats extends StatefulWidget {
  const FullStats({Key? key}) : super(key: key);

  @override
  State<FullStats> createState() => _FullStatsState();
}

class _FullStatsState extends State<FullStats> {
  int _selectedIndex = 0;
  int days = 1; //Set the time limit to 1 last day
  final chips = ["Today", "Last 7 days", "Last Month", "All Time"];

  @override
  Widget build(BuildContext context) {
    final Timestamp currTimeLimit = Timestamp.fromDate(
      DateTime.now().subtract(
        Duration(days: days),
      ),
    );
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Stats Deep Dive",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                chips.length,
                (index) {
                  return ChoiceChip(
                    selected: _selectedIndex == index,
                    label: Text(chips[index]),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedIndex = index;

                          if (_selectedIndex == 0) {
                            days = 1;
                          } else if (_selectedIndex == 1) {
                            days = 7;
                          } else if (_selectedIndex == 2) {
                            days = 30;
                          } else if (_selectedIndex == 3) {
                            days = 1000;
                          }
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("user/${HomePage.user!.uid}/transactions")
                .where("time", isGreaterThan: currTimeLimit)
                .get(),
            builder: (context, snapshot) {
              double spent = 0;
              double deposit = 0;
              int needs = 0;
              int wants = 0;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final documents = snapshot.data?.docs;
              //print(documents);

              if (documents!.isEmpty) {
                return const Center(
                  child: Text("No Transactions found!"),
                );
              }

              documents.forEach(((element) => {
                    if (element.get("transaction_sub_catagory") == "Want")
                      {wants += 1}
                    else if (element.get("transaction_sub_catagory") == "Need")
                      {needs += 1},
                    if (element.get("transaction_type") == "Deposit")
                      {
                        deposit += int.parse(element.get("amount")),
                      }
                    else
                      {spent += int.parse(element.get("amount"))}
                  }));

              return StatsCard(
                totalSpent: spent,
                netDeposit: deposit,
                needsCount: needs,
                wantsCount: wants,
                avgSpend: spent / days,
              );
            },
          ),
        ],
      ),
    ));
  }
}
