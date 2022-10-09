import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCard extends StatelessWidget {
  final String username;
  final String email;
  final String createdAt;

  const UserCard(
      {Key? key,
      required this.username,
      required this.email,
      required this.createdAt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          // Text(
          //   username.toString(),
          //   style:
          //       GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(
          //   height: 0,
          // ),
          const Icon(
            CupertinoIcons.person_fill,
            size: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            email.toString(),
            style:
                GoogleFonts.poppins(fontSize: 15, color: Colors.grey.shade600),
          ),

          // Text(
          //   createdAt.toString(),
          //   style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          // ),
        ],
      ),
    );
  }
}
