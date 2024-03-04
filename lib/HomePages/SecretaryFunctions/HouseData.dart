import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HouseData extends StatelessWidget {
  final String? societyId;
  const HouseData({super.key,required this.societyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('House List'),
        backgroundColor: HexColor("#8a76ba"),
      ),
      body: HouseCatalouge(societyId: societyId,),
    );
  }
}


class HouseCatalouge extends StatelessWidget {
  final String? societyId;
  const HouseCatalouge({super.key,required this.societyId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('House')
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
          return Center(child: Text('Society has no House'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data =
            docs[index].data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text('House Id: ${data['id']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('House No: ${data['house_no']}'),
                    Text('Ownership Type: ${data['ownership']}'),
                    Text('Society Name: ${data['society_id']}'),
                    Text('Member Name: ${data['Member_id']}'),
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
