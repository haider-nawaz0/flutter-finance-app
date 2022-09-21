import 'package:cloud_firestore/cloud_firestore.dart';

import '../Pages/home_page.dart';

class FirebaseFunctions {
  static var spent = 10;
  // static var user = FirebaseAuth.instance.currentUser;

  static var displayName = "";

  static Stream<QuerySnapshot> cycleTx() {
    // var spent = 10;
    Stream<QuerySnapshot> productRef = FirebaseFirestore.instance
        .collection("user/${HomePage.user!.uid}/transactions")
        .snapshots();
    // productRef.forEach((field) {
    //   field.docs.asMap().forEach((index, data) {
    //     if (field.docs[index]["transaction_type"] != "Deposit") {
    //       print(field.docs[index]["amount"]);

    //       spent += int.parse(field.docs[index]["amount"]);
    //       print(spent);
    //     }
    //   });
    // });
    //print("spent" + spent.toString());
    return productRef;
  }
}
