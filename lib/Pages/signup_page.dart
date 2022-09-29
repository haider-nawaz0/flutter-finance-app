import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/Pages/email_verify_screen.dart';
import 'package:finance_app/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();

  var isLoading = false;

  Future signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        var auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        //Sign in the User

        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        //Send the verification email to user
        await auth.user!.sendEmailVerification();

        //Add to Firebase

        var data = {
          "username": userNameController.text,
          "email": emailController.text,
          "time": DateTime.now(),
        };
        FirebaseFirestore.instance
            .collection("user")
            .doc(auth.user!.uid)
            .set(data);

        setState(() {
          isLoading = false;
        });
        if (!mounted) {}

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const EmailVerifyScreen(),
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Input all the fields!",
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Sign Up here.",
                    style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.normal,
                        color: Colors.purple),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.black45,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.black45,
                      ),
                      labelText: "Enter your Email",
                      //border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      labelStyle: const TextStyle(color: Colors.black45),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    cursorColor: Colors.black45,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black45),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black45,
                      ),
                      labelText: "Enter a Password",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 10,
                    cursorColor: Colors.black45,
                    controller: userNameController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black45),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),

                      focusColor: Colors.black45,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.black45,
                      ),
                      labelText: "Choose a Username",
                      // border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Username cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isLoading)
                    const Center(
                        child: CircularProgressIndicator(
                      color: Colors.purple,
                    )),
                  if (!isLoading)
                    Center(
                      child: GestureDetector(
                        onTap: () => signUp(context),
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                              child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          )),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 200,
                  ),
                  Center(
                    child: GestureDetector(
                      // onLongPress: (() => Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               const EmailVerifyScreen()),
                      //     )),
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      ),
                      child: Text(
                        "Already a Member? Login here...",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
