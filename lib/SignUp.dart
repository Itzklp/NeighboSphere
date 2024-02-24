import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    String fname="",lname="",gender="",email="",cpassword="",password="",contact="",society_name="";
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
                ElevatedButton(
                  onPressed: (){
                    setState(() {
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
                      'SIGNUP',
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
