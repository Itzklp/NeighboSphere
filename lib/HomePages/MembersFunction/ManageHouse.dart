import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../IDGenerator/IDGenerator.dart';

class ManageHouse extends StatefulWidget {
  final String? memberId;
  final String? societyId;
  const ManageHouse({Key? key, this.memberId, required this.societyId}) : super(key: key);

  @override
  State<ManageHouse> createState() => _ManageHouseState();
}

class _ManageHouseState extends State<ManageHouse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: Text('Manage House'),
      ),
      body: HouseList(memberId: widget.memberId),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMyPopup(context, widget.societyId, widget.memberId);
        },
        backgroundColor: HexColor("#8a76ba"),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showMyPopup(BuildContext context, String? societyId, String? memberId) {
    String house_id = '';
    String ownership = 'Owned'; // Default to 'Owned'

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add House'),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    house_id = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter House No',
                    label: const Text('House No'),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#8a76ba")),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#8a76ba"),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                DropdownButtonFormField<String>(
                  value: ownership,
                  onChanged: (value) {
                    setState(() {
                      ownership = value!;
                    });
                  },
                  items: ['Owned', 'Rented', 'To be Rented'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Ownership',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String id = UniqueRandomStringGenerator.generateUniqueString(15);
                Map<String, dynamic> houseData = {
                  'id': id,
                  'house_no': house_id,
                  'member_id': memberId,
                  'ownership': ownership,
                  'society_id': societyId
                };

                try {
                  // Add data to 'House' collection
                  await FirebaseFirestore.instance.collection("House").doc(id).set(houseData);

                  // Add additional fields for 'Funds' collection
                  Map<String, dynamic> fundsData = {
                    ...houseData,
                    'date': DateTime.now(),
                    'status': 'Pending',
                    'amount': '10000'
                  };
                  await FirebaseFirestore.instance.collection("Funds").doc(id).set(fundsData);

                  Navigator.of(context).pop();
                } catch (e) {
                  print("Error: $e");
                }
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }
}

class HouseList extends StatelessWidget {
  final String? memberId;
  const HouseList({Key? key, this.memberId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('House')
          .where('member_id', isEqualTo: memberId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return Center(child: Text('No House Data Found.'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
            return Card(
              elevation: 10.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(
                  'House No: ${data['house_no']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      'Ownership: ${data['ownership']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Society: ${data['society_id']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () => _deleteDocument(docs[index].id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteDocument(String id) {
    try {
      FirebaseFirestore.instance.collection('House').doc(id).delete();
      // Optional: Show a snackbar or message to indicate successful deletion
    } catch (e) {
      print("Error deleting document: $e");
      // Handle delete errors here
    }
  }
}
