import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neighbosphere/HomePages/Home.dart';
import 'package:neighbosphere/SignupPages/SignUp.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}
class _SignInState extends State<SignIn> {
  sigin(String email,String password)async{
    UserCredential? usercredential;
    try{
      usercredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
      });
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
  String email='',password='';
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0)),
            SizedBox(height: 20,),
            Image.asset(
              'assets/house.png', // Replace 'your_image.png' with your image path
              height: 150, // Adjust height as needed
            ),
            SizedBox(height: 20),
            // Welcome Text
            const Text(
              "Welcome back!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "We're glad to see you again. Sign in to manage your society effortlessly.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: obscureText, // This property hides the entered text
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
                              obscureText ? Icons.visibility : Icons.visibility_off,
                            ), // Eye icon
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
                        onPressed: (){
                          setState(() {
                            if(password.isEmpty || email.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "One of the field is empty",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                            else{
                              sigin(email, password);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("#8a76ba"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            )
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          child: const Text(
                            'SIGN IN',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0,),
                      TextButton(
                        onPressed: () {
                          _ForgotPassword(context);
                        },
                        child: const Text(
                          'FORGET PASSWORD',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF8a76ba)
                          ),
                        ),
                      ),

                      const SizedBox(height: 5.0,),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Center(
                          child: Text(
                            'or',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0,),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("#8a76ba"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            )
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),

                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ForgotPassword(BuildContext context) {
    String email="";
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Enter your Email'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    onChanged: (value){
                      email = value;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_rounded, color: Colors.black),
                      hintText: 'Enter E-mail',
                      label: const Text('E-mail'),
                      enabledBorder: OutlineInputBorder(
                          borderSide:  const BorderSide(color: Color(0xFF8a76ba)),
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
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    if(email == ""){
                      Fluttertoast.showToast(
                          msg: "Please Enter Email",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    else{
                      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                    }

                  });
                  Navigator.of(context).pop();
                },
                child: Text('Submit',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          );
        }
    );
  }
}

