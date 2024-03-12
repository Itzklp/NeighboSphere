import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../IDGenerator/IDGenerator.dart';



class MaintainReq extends StatefulWidget {
  final String? memberId;
  final String? societyId;
  const MaintainReq({super.key,required this.memberId,required this.societyId});

  @override
  State<MaintainReq> createState() => _MaintainReqState();
}

class _MaintainReqState extends State<MaintainReq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: Text('Maintenance Request'),
      ),
      body: MaintenanceList(societyId: widget.societyId,memberId: widget.memberId,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMyPopup(context,widget.societyId,widget.memberId);
        },
        backgroundColor: HexColor("#8a76ba"),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
  void _showMyPopup(BuildContext context,String? societyId,String? memberId) {
    String type = '';
    String description = '';
    String house_no = '';
    DateTime now = DateTime.now();
    String formatDate(DateTime date) => DateFormat('dd-MM-yyyy').format(date);
    String formattedDate = formatDate(now);

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Add Maintenance Request'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value){
                      house_no = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter House No',
                      label: const Text('House No'),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8a76ba")),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor("#8a76ba"),
                              width: 2.0
                          ),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0,),
                  TextField(
                    onChanged: (value){
                      type = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Maintenance Type',
                      label: const Text('Type'),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8a76ba")),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor("#8a76ba"),
                              width: 2.0
                          ),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0,),
                  TextField(
                    onChanged: (value){
                      description = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Maintenance Description',
                      label: const Text('Description'),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8a76ba")),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor("#8a76ba"),
                              width: 2.0
                          ),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  setState(() async {
                    String id = UniqueRandomStringGenerator.generateUniqueString(15);
                    await FirebaseFirestore.instance.collection("MaintenanceRequest").doc(id).set(
                        {
                          'id' : id,
                          'house_no' : house_no,
                          'member_id' : memberId,
                          'type' : type,
                          'society_id' : societyId,
                          'description' : description,
                          'status' : 'Not Read',
                          'date' : formattedDate
                        });
                    Navigator.of(context).pop();
                  });

                },
                child: Text('Request'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                ),
              ),
            ],
          );
        }
    );
  }
}

class MaintenanceList extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const MaintenanceList({super.key,required this.societyId, this.memberId});

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('MaintenanceRequest')
          .where('society_id', isEqualTo: societyId)
          .where('member_id', isEqualTo: memberId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('You have not made any Maintenance Request.'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data =
            docs[index].data() as Map<String, dynamic>;
            return Card(
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(
                  'Request ID: ${docs[index].id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    Text(
                      'Request Type: ${data['type']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Request Details: ${data['description']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'House No: ${data['house_no']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Member Id: ${data['member_id']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Date: ${data['date']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Status: ${data['status']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
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
      FirebaseFirestore.instance.collection('MaintenanceRequest').doc(id).delete();
      // Optional: Show a snackbar or message to indicate successful deletion
    } catch (e) {
      print("Error deleting document: $e");
      // Handle delete errors here
    }
  }
}
