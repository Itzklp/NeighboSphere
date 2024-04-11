import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neighbosphere/HomePages/TreasurerFunctions/FundLog.dart';
import 'package:neighbosphere/HomePages/TreasurerFunctions/Transactions.dart';

import '../../SignupPages/SignIn.dart';


class TreasurerHome extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const TreasurerHome({super.key,required this.societyId,required this.memberId});

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
              title: const Text('Add Transaction'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionLog(societyId: societyId, memberId: memberId)));
              },
            ),
            ListTile(
              title: const Text('Funds Log'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => FundLog(societyId: societyId,memberId: memberId,)));
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
