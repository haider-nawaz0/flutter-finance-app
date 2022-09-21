import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/utils/functions.dart';
import 'package:finance_app/widgets/transaction_card.dart';
import 'package:finance_app/widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPage();
}

class _TransactionsPage extends State<TransactionsPage> {
  var user = FirebaseAuth.instance.currentUser;

  final f = DateFormat('yyyy-MM-dd');
  var flag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
              child: Container(
            margin: const EdgeInsets.only(left: 25, top: 20),
            width: double.infinity,
            child: Text(
              "Transactions",
              style: GoogleFonts.poppins(
                fontSize: 25,
              ),
              textAlign: TextAlign.left,
            ),
          )),
          // const UserCard(username: "username", spent: "spent"),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("user/${user!.uid}/transactions")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final documents = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      int amount = int.parse(documents[index]['amount']);

                      FirebaseFunctions.spent += amount;
                      if (documents[index]['transaction_type'] != "Deposit") {
                        flag = false;
                      } else {
                        flag = true;
                      }
                      return SizedBox(
                        child: TransactionCard(
                          transactionType: documents[index]['transaction_type'],
                          transactionSubCatagory: documents[index]
                              ['transaction_sub_catagory'],
                          amount: amount.toString(),
                          dateTime: f
                              .format(documents[index]['time'].toDate())
                              .toString(),
                          flag: flag,
                        ),
                      );
                    },
                  );
                } else {
                  return const Text("");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
