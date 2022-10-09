import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/Pages/account_page.dart';
import 'package:finance_app/Pages/transaction_detail_page.dart';
import 'package:finance_app/widgets/full_stats_widget.dart';
import 'package:finance_app/widgets/main_stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../widgets/add_tx_widget.dart';
import '../widgets/transaction_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  //call the method to get the username
  static final user = FirebaseAuth.instance.currentUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final f = DateFormat("MMMM dd");

  var flag = true;

  @override
  Widget build(BuildContext context) {
    //final Timestamp now = Timestamp.fromDate(DateTime.now());
    final Timestamp lastMonth = Timestamp.fromDate(
      DateTime.now().subtract(const Duration(days: 30)),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  .collection("user/${HomePage.user!.uid}/transactions")
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
              padding: const EdgeInsets.only(right: 25),
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
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Text(
                "Recent Transactions",
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("user/${HomePage.user!.uid}/transactions")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.black);
                  }

                  final documents = snapshot.data!.docs;

                  if (documents.isEmpty) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset("assets/images/no-data.png"),
                    ));
                  }
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      int amount = int.parse(documents[index]['amount']);

                      if (documents[index]['transaction_type'] != "Deposit") {
                        flag = false;
                      } else {
                        flag = true;
                      }
                      return SizedBox(
                        child: Slidable(
                          key: const ValueKey(0),

                          // The start action pane is the one at the left or the top side.
                          endActionPane: ActionPane(
                            // A motion is a widget used to control how the pane animates.
                            motion: const ScrollMotion(),

                            // A pane can dismiss the Slidable.
                            dismissible: DismissiblePane(
                                onDismissed: () => deleteTransaction(
                                    context, documents[index].id)),

                            // All actions are defined in the children parameter.
                            children: [
                              // A SlidableAction can have an icon and/or a label.
                              SlidableAction(
                                onPressed: (context) => deleteTransaction(
                                    context, documents[index].id),
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => TrxDetailPage(
                                            trxType: documents[index]
                                                ['transaction_type'],
                                            expendType: documents[index]
                                                ['transaction_sub_catagory'],
                                            trxTime: documents[index]['time'],
                                            trxDesc: documents[index]
                                                ['descriptions'],
                                            amount: amount,
                                            docId: documents[index].id,
                                          )));
                            },
                            child: TransactionCard(
                              transactionType: documents[index]
                                  ['transaction_type'],
                              transactionSubCatagory: documents[index]
                                  ['transaction_sub_catagory'],
                              amount: amount.toString(),
                              dateTime: f
                                  .format(documents[index]['time'].toDate())
                                  .toString(),
                              flag: flag,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
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
        backgroundColor: Colors.black,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  void deleteTransaction(BuildContext context, String docID) {
    FirebaseFirestore.instance
        .collection("user/${HomePage.user!.uid}/transactions")
        .doc(docID)
        .delete();
  }
}
