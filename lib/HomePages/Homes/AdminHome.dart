import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:neighbosphere/HomePages/AdminFunctions/AddSociety.dart';
import 'package:neighbosphere/HomePages/AdminFunctions/ManageSociety.dart';
import 'package:neighbosphere/SignupPages/SignIn.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: Text('Admin Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: HexColor("#8a76ba"),
                ),
                child: Text('Home')
            ),
            ListTile(
              title: const Text('Add Society'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddSociety()));
              },
            ),
            ListTile(
              title: const Text('Manage Society'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ManageSociety()));
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () async{
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                } catch (e) {
                  print("Error signing out: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
