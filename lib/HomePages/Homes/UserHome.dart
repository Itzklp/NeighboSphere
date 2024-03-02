import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neighbosphere/HomePages/MembersFunction/ManageHouse.dart';

import '../../SignupPages/SignIn.dart';


class UserHome extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const UserHome({super.key,required this.memberId,required this.societyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: Text('Home'),
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
              title: const Text('Manage House'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ManageHouse(societyId: societyId,memberId: memberId,)));
              },
            ),
            ListTile(
              title: const Text('Visitor Record'),
              onTap: (){},
            ),
            ListTile(
              title: const Text('Maintenance Request'),
              onTap: (){},
            ),
            ListTile(
              title: const Text('Book Facility'),
              onTap: (){},
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
                  // Handle sign-out errors here
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
