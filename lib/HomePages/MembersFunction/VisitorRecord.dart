import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class VisitorRecord extends StatefulWidget {
  final String? memberId;
  final String? societyId;
  const VisitorRecord({super.key, required this.societyId, required this.memberId});

  @override
  State<VisitorRecord> createState() => _VisitorRecordState();
}

class _VisitorRecordState extends State<VisitorRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: Text('Visitor\'s Record'),
      ),
      body: VisitorList(memberId: widget.memberId, societyId: widget.societyId),
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
      future: _getHouseNosForMember(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final houseNos = snapshot.data;
        if (houseNos == null || houseNos.isEmpty) {
          return Center(child: Text('No Visitor Data Found.'));
        }
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ExpectedVisitor')
              .where('society_id', isEqualTo: societyId)
              .where('house_no', whereIn: houseNos)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return Center(child: Text('No visitors for these houses.'));
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
                          'House No: ${data['house_no']}',
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
        );
      },
    );
  }

  Future<List<String>> _getHouseNosForMember() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('House')
          .where('member_id', isEqualTo: memberId)
          .get();
      List<String> houseNos = querySnapshot.docs.map((doc) {
        print('House No: ${doc['house_no']}'); // Logging house_no for debugging
        return doc['house_no'] as String;
      }).toList();
      return houseNos;
    } catch (e) {
      print('Error getting house nos for member: $e');
      return [];
    }
  }
}
