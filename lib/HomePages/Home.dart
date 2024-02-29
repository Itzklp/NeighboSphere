import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbosphere/HomePages/UserHome.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? _data;

  Future<Map<String, dynamic>> fetchData(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('Members').doc(documentId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map if document not found
      }
    } catch (error) {
      print("Error fetching data: $error");
      throw error; // Rethrow the error for handling in the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = user?.uid;

    return FutureBuilder<Map<String, dynamic>>(
      future: fetchData(userId.toString()),
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
          _data = snapshot.data;
          print(_data?['desegination']);
          return UserHome(); // Pass the fetched data to UserHome
        }
      },
    );
  }
}
