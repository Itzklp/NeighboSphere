import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class ManageSociety extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: const Text('Manage Society'),
      ),
      body: SocietyDataList(),
    );
  }
}

class SocietyDataList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Society').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text(data['name']),
                subtitle: Text(data['address']),
                // Add more fields as needed
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
  void _deleteDocument(String documentId) {
    try {
      FirebaseFirestore.instance.collection('Society').doc(documentId).delete();
      // Optional: Show a snackbar or message to indicate successful deletion
    } catch (e) {
      print("Error deleting document: $e");
      // Handle delete errors here
    }
  }
}
