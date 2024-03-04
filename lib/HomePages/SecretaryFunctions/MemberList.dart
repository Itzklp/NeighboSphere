import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemberList extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const MemberList({super.key,required this.societyId,required this.memberId});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class MemberCatalouge extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const MemberCatalouge({super.key,required this.societyId,required this.memberId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Members')
          .where('society_id', isEqualTo: societyId)
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
          return Center(child: Text('Society has no Members'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data =
            docs[index].data() as Map<String, dynamic>;
            return Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Member Id: ${data['id']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('First Name: ${data['fname']}'),
                        Text('Last Name: ${data['lname']}'),
                        Text('Contact: ${data['contact']}'),
                        Text('E-mail: ${data['email']}'),
                        Text('Designation: ${data['designation']}'),
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
                  ElevatedButton(
                    onPressed: () {
                    },
                    child: Text('Change Designation'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void _deleteDocument(String id) {
    try {
      FirebaseFirestore.instance.collection('Member').doc(id).delete();
    } catch (e) {
      print("Error deleting document: $e");
    }
  }
}
