import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionCard extends StatelessWidget {
  final String transactionType;
  final String transactionSubCatagory;
  final String amount;
  final String dateTime;
  final bool flag; //Will be true if transaction is Deposit

  const TransactionCard({
    Key? key,
    required this.transactionType,
    required this.transactionSubCatagory,
    required this.amount,
    required this.dateTime,
    required this.flag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      height: 95,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.0),
        //     spreadRadius: 0,
        //     blurRadius: 0,
        //     offset: const Offset(0, 0), // changes position of shadow
        //   ),
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            //Circle with Icon
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    // offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: flag
                    ? const Icon(
                        CupertinoIcons.arrow_down_left,
                        size: 30,
                      )
                    : const Icon(
                        CupertinoIcons.arrow_up_right,
                        size: 30,
                      ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            //Column containing Transaction Type and Sub category
            Column(
              children: [
                Text(
                  transactionType,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  transactionSubCatagory,
                  style: const TextStyle(color: Colors.orange, fontSize: 16),
                ),
              ],
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
            ),

            //Column containing Amount and date
            Column(
              children: [
                Row(
                  children: [
                    flag
                        ? Text(
                            "+",
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          )
                        : Text(
                            "-",
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Rs. ${amount.toString()}",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: flag ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  dateTime.toString(),
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
