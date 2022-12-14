import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/widgets/stats_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FullStats extends StatefulWidget {
  const FullStats({Key? key}) : super(key: key);

  @override
  State<FullStats> createState() => _FullStatsState();
}

class _FullStatsState extends State<FullStats> {
  int _selectedIndex = 0;
  int days = 1; //Set the time limit to 1 last day
  final chips = [
    "Today",
    "This Week",
    "Last Month",
    "Last 6 Months",
    "All Time"
  ];

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
            padding: const EdgeInsets.only(left: 0, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          CupertinoIcons.back,
                          color: Colors.black,
                        )),
                    Text(
                      "Stats Deep Dive",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  chips.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(3),
                      child: ChoiceChip(
                        backgroundColor: Colors.black54,
                        selectedColor: Colors.black,
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
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
                                days = 120;
                              } else if (_selectedIndex == 4) {
                                days = 365;
                              }
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection(
                    "user/${FirebaseAuth.instance.currentUser!.uid}/transactions")
                .where(
                  "time",
                  isGreaterThan: currTimeLimit,
                )
                .get(),
            builder: (context, snapshot) {
              double spent = 0;
              double deposit = 0;
              int needs = 0;
              int wants = 0;
              int depositsCount = 0;
              int expendsCount = 0;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              }

              final documents = snapshot.data?.docs;
              //print(documents);

              if (documents!.isEmpty) {
                return const Center(
                  child: Text("Add Transactions to see Stat."),
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
                        depositsCount += 1
                      }
                    else
                      {
                        spent += int.parse(element.get("amount")),
                        expendsCount += 1,
                      }
                  }));

              return StatsCard(
                totalSpent: spent,
                netDeposit: deposit,
                needsCount: needs,
                wantsCount: wants,
                avgSpend: spent / days,
                depositsCount: depositsCount,
                expendsCount: expendsCount,
              );
            },
          ),
        ],
      ),
    ));
  }
}
