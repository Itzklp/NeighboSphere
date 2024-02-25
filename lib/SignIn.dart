import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email='',password='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
        child: Container(
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
                    //register the user
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
                  'SIGNIN',
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
      ),
    );
  }
}
