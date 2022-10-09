import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTxWidget extends StatefulWidget {
  const AddTxWidget({Key? key}) : super(key: key);

  @override
  State<AddTxWidget> createState() => _AddTxWidgetState();
}

class _AddTxWidgetState extends State<AddTxWidget> {
  final _formKey = GlobalKey<FormState>();
  var greenActive = true; //Deposit

  var subTxType = "Personal";
  var subTxToggle = true;

  void depositBtnClicked() {
    setState(() {
      txType = "Deposit";
      subTxType = "Personal";
      greenActive = true;
    });
  }

  void expendBtnClicked() {
    setState(() {
      subTxType = "Need";
      txType = "Expend";
      greenActive = false;
    });
  }

  var isLoading = false;
  var user = FirebaseAuth.instance.currentUser;
  //Controllers
  var amountController = TextEditingController();
  final descController = TextEditingController();
  var txType = "Deposit";
  //var subTx = "Need";

  //Add Data to Firestore
  Future addTransaction(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      var data = {
        "amount": amountController.text,
        "time": FieldValue.serverTimestamp(),
        "transaction_sub_catagory": subTxType,
        "transaction_type": txType,
        "descriptions": descController.text,
      };
      try {
        await FirebaseFirestore.instance
            .collection("user/${user!.uid}/transactions")
            .doc()
            .set(data);
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

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0, top: 0),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.pop(context),
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Text(
                  "Add Transaction",
                  style: GoogleFonts.poppins(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black45,
                  controller: amountController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.monetization_on,
                      color: Colors.black45,
                    ),
                    labelText: "Enter the amount",
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
                      return "Amount cannot be empty";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: depositBtnClicked,
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xff478778), width: 2),
                          color: greenActive
                              ? const Color(0xff478778)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                            child: Text(
                          "Deposit",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: greenActive
                                ? Colors.white
                                : const Color(0xff478778),
                          ),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: expendBtnClicked,
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xCCfe104c), width: 2),
                          color: greenActive
                              ? Colors.white
                              : const Color(0xCCfe104c),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                            child: Text(
                          "Expend",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: greenActive
                                ? const Color(0xCCfe104c)
                                : Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                if (!greenActive)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        subTxToggle = !subTxToggle;
                        subTxType = subTxToggle ? "Need" : "Want";
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 55,
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xff707B7C), width: 2),
                        color: subTxToggle
                            ? Colors.white
                            : const Color(0xff707B7C),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          subTxType,
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: subTxToggle
                                  ? const Color(0xff707B7C)
                                  : Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                TextFormField(
                  controller: descController,
                  cursorColor: Colors.black45,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Colors.black45,
                    ),
                    labelText: "Reason of transaction...",
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
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),

                //Add tx Button

                if (isLoading) const CircularProgressIndicator(),

                if (!isLoading)
                  GestureDetector(
                    onTap: () => addTransaction(context),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xff478778), width: 2),
                        color: const Color(0xff478778),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Add",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
