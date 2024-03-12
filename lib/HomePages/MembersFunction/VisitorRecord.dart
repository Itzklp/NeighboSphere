import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class VisitorRecord extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const VisitorRecord({super.key,required this.societyId,required this.memberId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: Text('Visitor\'s Record'),
      ),
      body: VisitorList(memberId: memberId,societyId: societyId,),
    );
  }
}


class VisitorList extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const VisitorList({Key? key, required this.memberId, required this.societyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getHouseIdsForMember(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final houseIds = snapshot.data;
        if (houseIds == null || houseIds.isEmpty) {
          return Center(child: Text('No Visitor Data Found.'));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: houseIds.map((houseId) {
            return Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Visitor')
                    .where('society_id', isEqualTo: societyId)
                    .where('house_id', isEqualTo: houseId)
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
                    return Center(child: Text('No visitors for this house.'));
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
                      return Card(
                        elevation: 5.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            'Visitor ID: ${docs[index].id}',
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
                                'Purpose: ${data['purpose']}',
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
                                'House Id: ${data['house_id']}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Contact: ${data['contact']}',
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
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<List<String>> _getHouseIdsForMember() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('House')
          .where('member_id', isEqualTo: memberId)
          .get();
      List<String> houseIds = querySnapshot.docs.map((doc) => doc['id'] as String).toList();
      return houseIds;
    } catch (e) {
      print('Error getting house IDs for member: $e');
      return [];
    }
  }
}

