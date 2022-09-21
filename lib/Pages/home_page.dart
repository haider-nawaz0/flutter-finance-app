import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/widgets/main_stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../widgets/add_tx_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  //call the method to get the username
  static final user = FirebaseAuth.instance.currentUser;

  // Future getUsername() async {
  //   final docRef = FirebaseFirestore.instance
  //       .collection("user")
  //       .where("email", isEqualTo: user?.email);
  //   docRef.get().then(
  //     (result) {
  //       // final data = result.data() as Map<String, dynamic>;
  //       // username = data['username'];
  //       List<QueryDocumentSnapshot<Map<String, dynamic>>> data = result.docs;
  //       data.forEach((element) {
  //         username = element.get("username");
  //         print(element.get("username"));
  //       });
  //     },
  //     onError: (e) => print("Error getting document: $e"),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("user/${user!.uid}/transactions")

              // .where("transaction_type", isNotEqualTo: "Deposit")
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
                spent: totalSpent, deposit: totalDeposit, avg: totalSpent / 30);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoModalBottomSheet(
              context: context, builder: (context) => const AddTxWidget());
        },
        backgroundColor: Colors.black,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
