import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbosphere/HomePages/Homes/SecreatoryHome.dart';
import 'package:neighbosphere/HomePages/Homes/SecurityHome.dart';
import 'package:neighbosphere/HomePages/Homes/TreasurerHome.dart';
import 'package:neighbosphere/HomePages/Homes/UserHome.dart';
import 'package:neighbosphere/HomePages/Homes/AdminHome.dart'; // Import AdminHome page

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? _memberData;
  Map<String, dynamic>? _adminData;

  Future<Map<String, dynamic>> fetchMemberData(String documentId) async {
    try {
      DocumentSnapshot memberSnapshot =
      await FirebaseFirestore.instance.collection('Members')
          .doc(documentId)
          .get();
      if (memberSnapshot.exists) {
        return memberSnapshot.data() as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map if member not found
      }
    } catch (error) {
      print("Error fetching member data: $error");
      throw error; // Rethrow the error for handling in the UI
    }
  }

  Future<Map<String, dynamic>> fetchAdminData(String documentId) async {
    try {
      DocumentSnapshot adminSnapshot =
      await FirebaseFirestore.instance.collection('Admin')
          .doc(documentId)
          .get();
      if (adminSnapshot.exists) {
        return adminSnapshot.data() as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map if admin not found
      }
    } catch (error) {
      print("Error fetching admin data: $error");
      throw error; // Rethrow the error for handling in the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = user?.uid;
    print(userId);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Future.wait([
        fetchMemberData(userId.toString()),
        fetchAdminData(userId.toString())
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        } else {
          _memberData = snapshot.data![0];
          _adminData = snapshot.data![1];
          print(_memberData);
          print(_adminData);

          // Check if member data exists
          if (_memberData != null && _memberData!.isNotEmpty) {
            String? designation = _memberData?['designation'];
            if (designation == 'Member') {
              return UserHome(memberId: userId,societyId: _memberData?['society'],);
            } else if (designation == 'Secretary') {
              return SecretaryHome();
            } else if (designation == 'Treasurer') {
              return TreasurerHome();
            } else if (designation == 'Security') {
              return SecurityHome(memberId: userId,societyId: _memberData?['society'],);
            }
          }
          // Check if admin data exists
          else if (_adminData != null && _adminData!.isNotEmpty) {
            return const AdminHome();
          }
          return const Scaffold(
            body: Center(
              child: Text(""),
            ),
          );
        }
      },
    );
  }
}