import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../IDGenerator/IDGenerator.dart';

class FeedbackWidgit extends StatefulWidget {
  final String? memberId;
  final String? societyId;
  const FeedbackWidgit({super.key,required this.memberId,required this.societyId});

  @override
  State<FeedbackWidgit> createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackWidgit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: Text('Feedback'),
      ),
      body: FeedbackList(memberId: widget.memberId,societyId: widget.societyId,),
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
    String description = '';

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Add Feedback'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value){
                      description = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter description',
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
                  const SizedBox(height: 15.0,),
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
                    await FirebaseFirestore.instance.collection("Feedback").doc(id).set(
                        {
                          'id' : id,
                          'member_id' : memberId,
                          'description' : description,
                          'status' : 'Not Seen'
                        });
                    Navigator.of(context).pop();
                  });

                },
                child: Text('Submit'),
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

class FeedbackList extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const FeedbackList({super.key,required this.societyId,required this.memberId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Feedback')
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
          return Center(child: Text('You have not submitted any Fidback'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data =
            docs[index].data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text('Feedback Id: ${data['id']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Member Id: ${data['member_id']}'),
                    Text('Description : ${data['description']}'),
                    Text('Status: ${data['status']}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  style: IconButton.styleFrom(
                      foregroundColor: Colors.red
                  ),
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
      FirebaseFirestore.instance.collection('Feedback').doc(id).delete();
    } catch (e) {
      print("Error deleting document: $e");
    }
  }
}
