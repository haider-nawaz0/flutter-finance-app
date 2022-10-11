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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.person_fill,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                username.toString(),
                style: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.email,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                email.toString(),
                style: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.date_range,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                createdAt.toString(),
                style: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
