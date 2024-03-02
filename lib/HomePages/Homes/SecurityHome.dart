import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neighbosphere/HomePages/MembersFunction/FeedbackPage.dart';
import 'package:neighbosphere/HomePages/MembersFunction/MaintainReq.dart';
import 'package:neighbosphere/HomePages/MembersFunction/ManageHouse.dart';
import 'package:neighbosphere/HomePages/MembersFunction/VisitorRecord.dart';
import 'package:neighbosphere/HomePages/MembersFunction/FeedbackPage.dart';
import 'package:neighbosphere/HomePages/SecurityFunctions/AddVisitor.dart';

import '../../SignupPages/SignIn.dart';


class SecurityHome extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const SecurityHome({super.key,required this.memberId,required this.societyId});

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
              title: const Text('Add Visitor'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddVisitor(societyId: societyId,memberId: memberId,)));
              },
            ),
            ListTile(
              title: const Text('Feedback'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackWidgit(memberId: memberId, societyId: societyId)));
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
