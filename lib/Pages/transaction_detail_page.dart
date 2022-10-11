import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TrxDetailPage extends StatelessWidget {
  final String trxType;
  final String expendType;
  final Timestamp trxTime;
  final String trxDesc;
  final int amount;
  final String docId;

  const TrxDetailPage(
      {Key? key,
      required this.trxType,
      required this.expendType,
      required this.trxTime,
      required this.trxDesc,
      required this.amount,
      required this.docId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("###,###.0#", "en_US");
    final fDate = DateFormat('dd MMMM yyyy, hh:mm a');
    bool isExpend = true;
    bool emptyDesc = true;
    if (trxType == "Deposit") {
      isExpend = false;
    }

    if (trxDesc.toString().isNotEmpty) {
      emptyDesc = false;
    }
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
                color: isExpend
                    ? const Color(0xCCfe104c)
                    : const Color(0xff478778),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              CupertinoIcons.back,
                              color: Colors.white,
                            )),
                        isExpend
                            ? Text(
                                "Funds Expended",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Funds Deposited",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                        IconButton(
                          onPressed: () => delTrx(context),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: isExpend
                            ? const Icon(
                                CupertinoIcons.arrow_up_right,
                                size: 50,
                                color: Color(0xCCfe104c),
                              )
                            : const Icon(
                                CupertinoIcons.arrow_down_left,
                                size: 50,
                                color: Color(0xff478778),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: isExpend
                          ? Text(
                              "- Rs ${f.format(amount).toString()}",
                              style: GoogleFonts.mulish(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "+ Rs ${f.format(amount).toString()}",
                              style: GoogleFonts.poppins(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    Text(
                      expendType,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xffffbf00),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      fDate.format(
                        trxTime.toDate(),
                      ),
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: const Color(0xfff5f5f5)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          if (!emptyDesc)
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  trxDesc,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Delete Transaction?'),
        content: const Text('This action cannot be undone'),
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

            onPressed: () {
              FirebaseFirestore.instance
                  .collection(
                      "user/${FirebaseAuth.instance.currentUser!.uid}/transactions")
                  .doc(docId)
                  .delete();

              Navigator.pop(context); //Remove the popup
              Navigator.pop(context); //Go back
            },
            child: const Text('Yeah, do it'),
          ),
        ],
      ),
    );
  }

  void delTrx(BuildContext context) {
    _showAlertDialog(
      context,
    );
  }
}
