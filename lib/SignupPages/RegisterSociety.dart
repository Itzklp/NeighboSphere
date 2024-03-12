import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neighbosphere/HomePages/Home.dart';
import 'package:neighbosphere/SignupPages/SignIn.dart';

import '../IDGenerator/IDGenerator.dart';

class RegisterSociety extends StatefulWidget {
  const RegisterSociety({super.key});

  @override
  State<RegisterSociety> createState() => _RegisterSocietyState();
}

class _RegisterSocietyState extends State<RegisterSociety> {
  addSociety(String society,String address,String contact){
    String id = UniqueRandomStringGenerator.generateUniqueString(15);
    FirebaseFirestore.instance.collection("SocietyRequest").doc(id).set(
        {
          "id":id,
          "address":address,
          "secretary_contact":contact,
          "name":society
        }).then((value){
      print('Data inserted');
    });
  }
  signUp(String email,String password)async{
    UserCredential? usercredential;
    try{
      usercredential =await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch(ex){
      Fluttertoast.showToast(
          msg: ex.code.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  addData(String fname,String lname,String email,String contact,String society_name,String Desegnation) async{
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = "";
    userId = user?.uid;
    await FirebaseFirestore.instance.collection("Members").doc(userId).set(
        {
          "id":userId,
          "email":email,
          "contact":contact,
          "fname":fname,
          "lname":lname,
          "society":society_name,
          "designation":Desegnation
        }).then((value){
      print('Data inserted');
    });
  }

  bool obscureText_1 = true;
  bool obscureText_2 = true;
  @override
  Widget build(BuildContext context) {
    bool obscureText = true;
    String fname="",lname="",gender="",email="",cpassword="",password="",contact="",society_name="",society_address="";
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Image.asset(
              'assets/house3.png', // Replace 'your_image.png' with your image path
              height: 150, // Adjust height as needed
            ),
            SizedBox(height: 10),
            // Welcome Text
            Text(
              "Welcome to Neighbosphere!!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Register your society now for streamlined management and vibrant community connections. Let's build a better neighborhood together!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      onChanged: (value){
                        fname = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_2_rounded, color: Colors.black),
                        hintText: 'Enter the First Name',
                        label: const Text('First Name'),
                        enabledBorder: OutlineInputBorder(
                            borderSide:  BorderSide(color: HexColor("#8a76ba")),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF8a76ba),
                                width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    TextField(
                      onChanged: (value){
                        lname = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_2_rounded, color: Colors.black),
                        hintText: 'Enter the Last Name',
                        label: const Text('Last Name'),
                        enabledBorder: OutlineInputBorder(
                            borderSide:  BorderSide(color: HexColor("#8a76ba")),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF8a76ba),
                                width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    TextField(
                      onChanged: (value){
                        email = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_rounded, color: Colors.black),
                        hintText: 'Enter E-mail',
                        label: const Text('E-mail'),
                        enabledBorder: OutlineInputBorder(
                            borderSide:  BorderSide(color: HexColor("#8a76ba")),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF8a76ba),
                                width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        contact = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone, color: Colors.black),
                        hintText: 'Enter Contact',
                        label: const Text('Phone'),
                        enabledBorder: OutlineInputBorder(
                            borderSide:  BorderSide(color: HexColor("#8a76ba")),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF8a76ba),
                                width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    TextField(
                      onChanged: (value){
                        society_name = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.house, color: Colors.black),
                        hintText: 'Enter the Society name',
                        label: const Text('Society'),
                        enabledBorder: OutlineInputBorder(
                            borderSide:  BorderSide(color: HexColor("#8a76ba")),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF8a76ba),
                                width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    TextField(
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: obscureText_1, // This property hides the entered text
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_rounded, color: Colors.black), // Changed to lock icon
                        hintText: 'Password',
                        labelText: 'Password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8a76ba")),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF8a76ba),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // Added suffix icon for toggling visibility
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText_1 ? Icons.visibility : Icons.visibility_off,
                          ), // Eye icon
                          onPressed: () {
                            setState(() {
                              // Toggle the obscureText property
                              obscureText_1 = !obscureText_1;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    TextField(
                      onChanged: (value) {
                        cpassword = value;
                      },
                      obscureText: obscureText_2, // This property hides the entered text
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_rounded, color: Colors.black), // Changed to lock icon
                        hintText: 'Confirm Password',
                        labelText: 'Confirm Password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8a76ba")),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF8a76ba),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // Added suffix icon for toggling visibility
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText_2 ? Icons.visibility : Icons.visibility_off,
                          ), // Eye icon
                          onPressed: () {
                            setState(() {
                              // Toggle the obscureText property
                              obscureText_2 = !obscureText_2;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 15.0,),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      onChanged: (value){
                        society_address = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.home_filled, color: Colors.black),
                        hintText: 'Enter Society Address',
                        label: const Text('Address'),
                        enabledBorder: OutlineInputBorder(
                            borderSide:  BorderSide(color: HexColor("#8a76ba")),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF8a76ba),
                                width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0,),
                    ElevatedButton(
                      onPressed: () async{
                        setState(() async{
                          bool res = password == cpassword;
                          if(!res && (password.isEmpty || fname.isEmpty || lname.isEmpty || email.isEmpty || contact.isEmpty || society_name.isEmpty || password.isEmpty || society_address.isEmpty)){
                            Fluttertoast.showToast(
                                msg: "Either one of the field is empty or Passwords dont match",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                          else{
                            addSociety(society_name, society_address, contact);
                            await signUp(email, password);
                            User? user = FirebaseAuth.instance.currentUser;
                            if(user !=null){
                              addData(fname, lname, email, contact, society_name, "Secretary");
                            }
                            else{
                              print('Current user is null');
                            }
                          }
                        });
                        // Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8a76ba),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        child: const Text(
                          'REGISTER',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25.0,),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).popUntil(ModalRoute.withName('/root'));
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                      },
                      child: const Text(
                        'Already have an account? Login here.',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8a76ba)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

