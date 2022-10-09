import 'package:finance_app/Pages/email_verify_screen.dart';
import 'package:finance_app/Pages/login_page.dart';
import 'package:finance_app/Pages/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const ores = [DeviceOrientation.portraitUp];
  SystemChrome.setPreferredOrientations(ores);

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (FirebaseAuth.instance.currentUser!.emailVerified) {
              return const TabsScreen();
            } else {
              return const EmailVerifyScreen();
            }
          } else {
            return const LoginPage();
          }
        }),
      ),
    );
  }
}
