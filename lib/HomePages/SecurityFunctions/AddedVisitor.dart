import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ExpectedVisitor extends StatelessWidget {
  final String? societyId;
  final String? memberId;
  const ExpectedVisitor({super.key,required this.memberId,required this.societyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Expected Visitor'),
          backgroundColor: HexColor("#8a76ba"),
        ),
        body: ExpectedVisitorList(memberId: memberId,societyId: societyId,),
    );
  }
}

class ExpectedVisitorList extends StatelessWidget {
  final String? societyId;
  final String? memberId;
  const ExpectedVisitorList({super.key,required this.memberId,required this.societyId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ExpectedVisitor')
          .where('society_id', isEqualTo: societyId)
          .where('date', isGreaterThanOrEqualTo: DateTime.now().toIso8601String().substring(0, 10))
          .where('date', isLessThan: DateTime.now().add(Duration(days: 1)).toIso8601String().substring(0, 10))
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
          return Center(child: Text('No Visitors'));
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
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  'Visitor ID: ${data['id']}',
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
                      'Visitor Name: ${data['name']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Visitor Contact: ${data['contact']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Visited House: ${data['house_no']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Purpose: ${data['purpose']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            );

          },
        );
      },
    );
  }
}

