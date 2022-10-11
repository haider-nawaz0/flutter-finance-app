import 'package:finance_app/Pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<ContentConfig> listContentConfig = [];

  @override
  void initState() {
    super.initState();

    listContentConfig.add(
      ContentConfig(
        title: "Daily Expense Tracker",
        styleTitle: GoogleFonts.poppins(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        // marginTitle: const EdgeInsets.only(top: 20),
        description: "Finances made Simple.",
        pathImage: "assets/images/intro-image-1.png",
        styleDescription: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xff478778),
        widthImage: 300,
        heightImage: 300,
      ),
    );
    listContentConfig.add(ContentConfig(
      title: "",
      styleTitle: GoogleFonts.poppins(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      description:
          "Study your habit of spending with the help of insightful analytics.",
      styleDescription: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white,
      ),
      pathImage: "assets/images/manage-money.png",
      widthImage: 300,
      heightImage: 300,
      backgroundColor: const Color(0xCCfe104c),
      backgroundImageFit: BoxFit.cover,
    ));
    listContentConfig.add(
      ContentConfig(
        title: "",
        description: "Be the master of your world and make rational decisions.",
        pathImage: "assets/images/intro-image-3.png",
        styleDescription: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white,
        ),
        widthImage: 300,
        heightImage: 300,
        backgroundColor: const Color(0xff707B7C),
      ),
    );
  }

  void onDonePress() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroSlider(
        indicatorConfig: const IndicatorConfig(
          colorActiveIndicator: Colors.white,
        ),
        isShowSkipBtn: false,
        isShowNextBtn: false,
        isShowPrevBtn: false,
        // ignore: prefer_const_constructors
        doneButtonStyle: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return size 40, otherwise 20

            return const Color(0xffffffff);
          }),
        ),
        key: UniqueKey(),
        listContentConfig: listContentConfig,
        onDonePress: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        ),
      ),
    );
  }
}
