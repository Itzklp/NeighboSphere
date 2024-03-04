import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:neighbosphere/HomePages/MembersFunction/ManageHouse.dart';
import 'package:neighbosphere/HomePages/SecretaryFunctions/FacilityManagement.dart';
import 'package:neighbosphere/HomePages/SecretaryFunctions/HouseData.dart';
import 'package:neighbosphere/HomePages/SecretaryFunctions/MemberList.dart';
import '../../SignupPages/SignIn.dart';


class SecretaryHome extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const SecretaryHome({super.key,required this.societyId,required this.memberId});

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
              title: const Text('House List'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HouseData(societyId: societyId)));
              },
            ),
            ListTile(
              title: const Text('Manage Members'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MemberList(societyId: societyId, memberId: memberId)));
              },
            ),
            ListTile(
              title: const Text('Member Request'),
              onTap: (){},
            ),
            ListTile(
              title: const Text('Facility Management'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => FacilityManagement(memberId: memberId, societyId: societyId)));
              },
            ),
            ListTile(
              title: const Text('Member Request'),
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
