import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/Pages/account_page.dart';
import 'package:finance_app/widgets/full_stats_widget.dart';
import 'package:finance_app/widgets/main_stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../widgets/add_tx_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  //call the method to get the username
  static final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    //final Timestamp now = Timestamp.fromDate(DateTime.now());
    final Timestamp lastMonth = Timestamp.fromDate(
      DateTime.now().subtract(const Duration(days: 30)),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => {
                            //Open bottom sheet to show user Profile
                            showCupertinoModalBottomSheet(
                                expand: true,
                                context: context,
                                builder: (context) => const AccountPage())
                          },
                      icon: const Icon(
                        CupertinoIcons.profile_circled,
                        size: 35,
                      ))
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("user/${user!.uid}/transactions")
                  .where("time", isGreaterThan: lastMonth)
                  .snapshots(),
              builder: (context, snapshot) {
                double totalSpent = 0;
                double totalDeposit = 0;

                final documents = snapshot.data?.docs;
                //print(documents);

                documents?.forEach(((element) => {
                      if (element.get("transaction_type") == "Deposit")
                        {totalDeposit += int.parse(element.get("amount"))}
                      else
                        {totalSpent += int.parse(element.get("amount"))}
                    }));

                return MainStats(
                    spent: totalSpent,
                    deposit: totalDeposit,
                    avg: totalSpent / 30);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const FullStats()));
                    },
                    child: Text(
                      "Show More",
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoModalBottomSheet(
              expand: true,
              context: context,
              builder: (context) => const AddTxWidget());
        },
        backgroundColor: Colors.black45,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
