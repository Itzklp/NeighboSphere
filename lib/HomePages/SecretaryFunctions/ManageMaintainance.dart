import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MaintenanceRequestListPage extends StatelessWidget {
  final String? societyId;
  const MaintenanceRequestListPage({Key? key, this.societyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: const Text('Manage Maintenance Requests'),
      ),
      body: MaintenanceRequestList(societyId: societyId),
    );
  }
}

class MaintenanceRequestList extends StatelessWidget {
  final String? societyId;
  const MaintenanceRequestList({Key? key, this.societyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('MaintenanceRequest')
          .where('society_id', isEqualTo: societyId) // Removed extra semicolon here
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
          return Center(child: Text('No Maintenance Requests Found.'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
            final bool isSeen = data['status'] == 'Seen';

            return Card(
              elevation: 10.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  'Request ID: ${data['id']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      'Description: ${data['description']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Status: ${data['status']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Date: ${data['date']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'House: ${data['house_no']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Type: ${data['type']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Member: ${data['member_id']}',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                trailing: isSeen
                    ? null // If already seen, do not display the button
                    : IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    _updateRequestStatus(docs[index].id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _updateRequestStatus(String id) {
    try {
      FirebaseFirestore.instance.collection('MaintenanceRequest').doc(id).update({'status': 'Seen'});
      // Optional: Show a snackbar or message to indicate successful status update
    } catch (e) {
      print("Error updating request status: $e");
      // Handle update errors here
    }
  }
}
