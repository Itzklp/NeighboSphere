import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../IDGenerator/IDGenerator.dart';

class FeedbackWidgit extends StatefulWidget {
  final String? memberId;
  final String? societyId;
  const FeedbackWidgit({super.key, required this.memberId, required this.societyId});

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
      body: FeedbackList(memberId: widget.memberId, societyId: widget.societyId),
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
    String description = '';

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Feedback'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      description = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter description',
                      label: const Text('Description'),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8a76ba")),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8a76ba"), width: 2.0),
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() async {
                    String id = UniqueRandomStringGenerator.generateUniqueString(15);
                    await FirebaseFirestore.instance.collection("Feedback").doc(id).set({
                      'id': id,
                      'member_id': memberId,
                      'description': description,
                      'status': 'Not Seen'
                    });
                    Navigator.of(context).pop();
                  });
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          );
        });
  }
}

class FeedbackList extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const FeedbackList({super.key, required this.societyId, required this.memberId});

  Future<String> _getMemberName(String memberId) async {
    DocumentSnapshot memberDoc = await FirebaseFirestore.instance.collection('Members').doc(memberId).get();
    return memberDoc['fname'];
  }

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
          return Center(child: Text('You have not submitted any Feedback'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
            return FutureBuilder(
              future: _getMemberName(data['member_id']),
              builder: (context, AsyncSnapshot<String> memberNameSnapshot) {
                if (memberNameSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (memberNameSnapshot.hasError) {
                  return Center(child: Text('Error: ${memberNameSnapshot.error}'));
                }
                return Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text('Description: ${data['description']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('Feedback Id: ${data['id']}',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),),
                        Text('Member Name: ${memberNameSnapshot.data}',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),),
                        Text('Status: ${data['status']}',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      style: IconButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () => _deleteDocument(docs[index].id),
                    ),
                  ),
                );
              },
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
