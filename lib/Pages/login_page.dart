import 'package:finance_app/Pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Future signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.toString().trim(),
            password: passwordController.text.toString().trim());
        setState(() {
          isLoading = false;
        });

        // if (!mounted) {}
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const HomePage()),
        // );
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
              child: SingleChildScrollView(
                //physics: const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 0,
                        ),
                        Text(
                          "Hi, Welcome back!",
                          style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: SizedBox(
                              height: 250,
                              width: 250,
                              child: Image.asset(
                                "assets/images/login-bro.png",
                              )),
                        ),
                        const SizedBox(
                          height: 20,
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
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black45,
                            ),
                            labelText: "Enter your Password",
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
                              return "Password cannot be empty";
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
                            color: Colors.black,
                          )),
                        if (!isLoading)
                          Center(
                            child: GestureDetector(
                              onTap: () => signIn(
                                context,
                              ),
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                    child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                )),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()),
                            ),
                            child: Text(
                              "Create a new account Instead!",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // Center(
                        //   child: GestureDetector(
                        //     onTap: () async => {
                        //       await FirebaseAuth.instance
                        //           .sendPasswordResetEmail(
                        //               email: "wj9971571@gmail.com")
                        //     },
                        //     child: Text(
                        //       "Forgot Password?",
                        //       style: GoogleFonts.poppins(
                        //           fontSize: 14, color: Colors.black45),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
