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
    setState(() {
      isLoading = true;
    });

    var data = {
      "amount": amountController.text,
      "time": DateTime.now(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //height: 500,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                "Add Transaction",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Amount",
                ),
              ),
              const SizedBox(
                height: 30,
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
                        border: Border.all(color: Colors.green, width: 2),
                        color: greenActive ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                          child: Text(
                        "Deposit",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: greenActive ? Colors.white : Colors.green,
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
                        border: Border.all(color: Colors.red, width: 2),
                        color: greenActive ? Colors.white : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                          child: Text(
                        "Expend",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: greenActive ? Colors.red : Colors.white,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
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
                      border: Border.all(color: Colors.blueGrey, width: 2),
                      color: subTxToggle ? Colors.white : Colors.blueGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        subTxType,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: subTxToggle ? Colors.blueGrey : Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Description (Optional)",
                ),
              ),

              const SizedBox(
                height: 90,
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
                      border: Border.all(color: Colors.green, width: 2),
                      color: Colors.green,
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
    );
  }
}
