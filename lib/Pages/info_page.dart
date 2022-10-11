import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 0, top: 15),
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
//               Text(
//                 """There is one thing that we almost do every day and that is exchange money. We're either making it or spending it.
// \nThere are countless examples of how people have made millions but due to the lack of their money-managing skills, they went broke.
// \nWe've created this app to assist you keep track of your regular spending patterns. """,
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   color: Colors.black,
//                 ),
//                 textAlign: TextAlign.justify,
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 "How does this work?",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//                 textAlign: TextAlign.start,
//               ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   "Add every transaction and, we’ll do the rest.",
              //   style: GoogleFonts.poppins(
              //     fontSize: 16,
              //     color: Colors.black,
              //   ),
              //   textAlign: TextAlign.justify,
              // ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "This app will help you keep track of your regular spending patterns.",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "What is a transaction?",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "A transaction is simply the exchange of money. It can be a deposit or an expenditure.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "What is Deposit?",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "The money you earn or receive like when you get your salary, your pocket money, or revenue from some freelance work.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "What is Expend?",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "The money that you spend.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "What is Need/Want?",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                """Needs are our basic necessities that we can't ignore like buying food in university or paying commute fees.\n 
"Wants" stands for the expenditure that could've been avoided.""",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 20,
              ),

              // Text(
              //   "What to do now?",
              //   style: GoogleFonts.poppins(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 18,
              //   ),
              //   textAlign: TextAlign.start,
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   """With the help of built-in analytics we’ll help you spend it wisely. So that you can fully appreciate your daily life while still setting aside money for rainy days.""",
              //   style: GoogleFonts.poppins(
              //     fontSize: 16,
              //     color: Colors.black,
              //   ),
              //   textAlign: TextAlign.justify,
              // ),
              const SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              //   child: Text(
              //     "Earning money is not the hard part, but maintaining it.",
              //     style: GoogleFonts.poppins(
              //       fontSize: 18,
              //       color: Colors.black,
              //       fontWeight: FontWeight.bold,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // const SizedBox(
              //   height: 40,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
