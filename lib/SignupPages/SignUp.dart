import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neighbosphere/HomePages/Home.dart';
import 'package:neighbosphere/SignupPages/RegisterSociety.dart';
import 'package:neighbosphere/SignupPages/SignIn.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
  Future<void> addData(String fname, String lname, String email, String contact, String society_name, String Desegnation) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      await FirebaseFirestore.instance.collection("Members").doc(userId).set({
        "id": userId,
        "email": email,
        "contact": contact,
        "fname": fname,
        "lname": lname,
        "society": society_name,
        "designation": Desegnation
      }).then((value) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
      }).catchError((error) {
        print('Failed to insert data: $error');
      });
    } else {
      print('Current user is null');
    }
  }
  @override
  Widget build(BuildContext context) {
    bool obscureText = true;
    String fname="",lname="",gender="",email="",cpassword="",password="",contact="",society_name="";
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Image.asset(
              'assets/house2.png', // Replace 'your_image.png' with your image path
              height: 150, // Adjust height as needed
            ),
            SizedBox(height: 20),
            // Welcome Text
            const Text(
              "Welcome to Neighbosphere!!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Sign up now to connect with neighbors, manage your society, and discover local events. Let's build a vibrant community together!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
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
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: true, // This property hides the entered text
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
                            color: Colors.purple,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // Added suffix icon for toggling visibility
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility), // Eye icon
                          onPressed: () {
                            setState(() {
                              // Toggle the obscureText property
                              obscureText = !obscureText;
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
                      obscureText: true, // This property hides the entered text
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
                            color: Colors.purple,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // Added suffix icon for toggling visibility
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility), // Eye icon
                          onPressed: () {
                            setState(() {
                              // Toggle the obscureText property
                              obscureText = !obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0,),
                    ElevatedButton(
                      onPressed: ()async{
                        setState(() async{
                          bool res = password == cpassword;
                          if(!res && (password.isEmpty || fname.isEmpty || lname.isEmpty || email.isEmpty || contact.isEmpty || society_name.isEmpty || password.isEmpty)){
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
                            await signUp(email, password);
                            User? user = FirebaseAuth.instance.currentUser;
                            if(user !=null){
                              addData(fname, lname, email, contact, society_name, "Member");
                            }
                            else{
                              print('Current user is null');
                            }
                          }
                        });
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
                          'SIGNUP',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(25.0),
                      child: const Center(
                        child: Text(
                            'or',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold
                            ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterSociety()));
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
                          'REGISTER YOUR SOCIETY',
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
          ],
        ),
      ),
    );
  }
}