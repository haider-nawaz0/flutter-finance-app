import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/Pages/signup_page.dart';
import 'package:finance_app/Pages/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  // void sendEmailVerification() async {

  bool isEmailVerified = false;
  bool emailSent = false;
  Timer? timer;

  Future cancel(BuildContext context) async {
    //Now del the data from the database
    final User user = FirebaseAuth.instance.currentUser!;

    FirebaseFirestore.instance.collection("user").doc(user.uid).delete().then(
          (doc) => {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Cancelling...",
                ),
                backgroundColor: Colors.red,
              ),
            )
          },
          onError: (e) => {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.toString(),
                ),
                backgroundColor: Colors.red,
              ),
            )
          },
        );

    //Delete the user and his data from the database
    await user.delete();

    if (!mounted) {}
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUp(),
      ),
    );
  }

  Future sendEmailVerification(BuildContext context) async {
    if (!emailSent) {
      //await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "A verification email has already been sent. Please wait for 5 min to retry again.",
          ),
          backgroundColor: Colors.green,
        ),
      );

      emailSent = true;
    }

    Timer(const Duration(minutes: 5), () {
      setState(() {
        emailSent = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      FirebaseAuth.instance.currentUser!.reload();

      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });

      if (isEmailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Eamil Verified Successfully",
            ),
            backgroundColor: Colors.green,
          ),
        );
        timer!.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                "Woah, slow down",
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
              Text(
                "Verify your email to proceed.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(35),
                child: Text(
                  "Please check your inbox and follow the instructions to verify your email. Make sure to check your Spam folder.\n\n You'll be automatically redirected to the App once you verify your email.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              !isEmailVerified
                  ? GestureDetector(
                      onTap: () => cancel(context),
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                            child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        )),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TabsScreen(),
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                            child: Text(
                          "Proceed",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        )),
                      ),
                    ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: GestureDetector(
                  onTap: () => sendEmailVerification(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "Request Email Verification Again.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: emailSent ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
