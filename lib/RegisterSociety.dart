import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neighbosphere/Home.dart';
import 'package:neighbosphere/SignIn.dart';

class RegisterSociety extends StatefulWidget {
  const RegisterSociety({super.key});

  @override
  State<RegisterSociety> createState() => _RegisterSocietyState();
}

class _RegisterSocietyState extends State<RegisterSociety> {
  addSociety(String society,String address,String contact){
    final random = Random();
    String id = String.fromCharCodes(Iterable.generate(
        5, (_) => 'abcdefghijklmnopqrstuvwxyz0123456789'.codeUnitAt(random.nextInt(36))));

    FirebaseFirestore.instance.collection("Society").doc(id).set(
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
  addData(String fname,String lname,String email,String contact,String society_name,String Desegnation){
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = "";
    userId = user?.uid;
    FirebaseFirestore.instance.collection("Members").doc(userId).set(
        {
          "id":userId,
          "email":email,
          "contact":contact,
          "fname":fname,
          "lname":lname,
          "society":society_name,
          "desegination":Desegnation
        }).then((value){
      print('Data inserted');
    });
  }

  @override
  Widget build(BuildContext context) {
    String fname="",lname="",gender="",email="",cpassword="",password="",contact="",society_name="",society_address="";
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                            color: Colors.purple,
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
                            color: Colors.purple,
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
                            color: Colors.purple,
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
                            color: Colors.purple,
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
                            color: Colors.purple,
                            width: 2.0
                        ),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                TextField(
                  onChanged: (value){
                    password = value;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password_rounded, color: Colors.black),
                    hintText: 'Password',
                    label: const Text('Password'),
                    enabledBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color: HexColor("#8a76ba")),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.purple,
                            width: 2.0
                        ),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                TextField(
                  onChanged: (value){
                    cpassword = value;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password_rounded, color: Colors.black),
                    hintText: 'Confirm Password',
                    label: const Text('Confirm Password'),
                    enabledBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color: HexColor("#8a76ba")),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.purple,
                            width: 2.0
                        ),
                        borderRadius: BorderRadius.circular(10.0)
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
                            color: Colors.purple,
                            width: 2.0
                        ),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                  ),
                ),
                const SizedBox(height: 25.0,),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
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
                        signUp(email, password);
                        addData(fname, lname, email, contact, society_name, "Secretary");
                        Navigator.push(context, MaterialPageRoute(builder: (contact)=>Home()));
                      }
                    });
                    // Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

