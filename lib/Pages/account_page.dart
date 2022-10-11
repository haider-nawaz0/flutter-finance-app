import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: (() => Navigator.pop(context)),
                  icon: const Icon(
                    Icons.cancel_rounded,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("user")
                  .doc(user!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: CupertinoButton(
                padding: const EdgeInsets.all(0),
                color: Colors.red,
                child: const Center(child: Text("Sign Out")),
                onPressed: () => signOut(context)),
          ),
        ],
      )),
    );
  }
}

signOut(BuildContext context, [bool mounted = true]) async {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('Sign out?'),
      content: const Text(
          'Proceed with this action? You can sign in again with you email and password.'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Nope'),
        ),
        CupertinoDialogAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as deletion, and turns
          /// the action's text color to red.
          /// The action
          isDestructiveAction: true,

          onPressed: () async {
            if (!mounted) {}
            Navigator.pop(context);
            Navigator.pop(context);
            await FirebaseAuth.instance.signOut();
          },
          child: const Text('Log out'),
        ),
      ],
    ),
  );
}
