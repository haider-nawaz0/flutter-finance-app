import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 15),
            child: GestureDetector(
              onTap: () => {
                Navigator.pop(context),
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Done",
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("user")
                  .doc(HomePage.user!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final documents = snapshot.data as DocumentSnapshot;
                final time =
                    DateTime.parse(documents["time"].toDate().toString());

                return UserCard(
                    username: documents["username"],
                    email: documents["email"],
                    createdAt:
                        "Joined on ${DateFormat('dd-MMM-yyy').format(time)}");
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Sign Out"),
              IconButton(
                onPressed: () => {Navigator.pop(context), signOut()},
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}

signOut() async {
  await FirebaseAuth.instance.signOut();
}
