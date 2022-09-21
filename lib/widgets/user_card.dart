import 'package:finance_app/widgets/add_tx_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class UserCard extends StatelessWidget {
  final String username;
  final String spent;

  const UserCard({Key? key, required this.username, required this.spent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final occy = NumberFormat("#,##0", "en_US");
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              "Hi, $username!",
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Text(
                "Rs. ",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                occy.format(int.parse(spent)),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "spent so far",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: (() => {
                  showCupertinoModalBottomSheet(
                      expand: false,
                      context: context,
                      builder: (context) => const AddTxWidget()),
                }),
            child: Container(
              alignment: Alignment.centerLeft,
              width: 160,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child: Text(
                "Add Transaction",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
