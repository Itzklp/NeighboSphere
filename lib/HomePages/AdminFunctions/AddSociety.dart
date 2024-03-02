import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class AddSociety extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: const Text('Society Requests'),
      ),
      body: SocietyDataListRequest(),
    );
  }
}

class SocietyDataListRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('SocietyRequest').snapshots(),
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data['address']}'),
                    Text('Secretary Contact: ${data['secretary_contact']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check),
                      style: IconButton.styleFrom(
                          foregroundColor: Colors.green
                      ),
                      onPressed: () => _addSociety(docs[index].id,data),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      style: IconButton.styleFrom(
                          foregroundColor: Colors.red
                      ),
                      onPressed: () => _deleteDocument(docs[index].id),
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
  void _deleteDocument(String documentId) {
    try {
      FirebaseFirestore.instance.collection('SocietyRequest').doc(documentId).delete();
      // Optional: Show a snackbar or message to indicate successful deletion
    } catch (e) {
      print("Error deleting document: $e");
      // Handle delete errors here
    }
  }

  void _addSociety(String documentId, Map<String, dynamic> requestData) {
    try {
      // Store the data from SocietyRequest into Society collection
      // FirebaseFirestore.instance.collection('Society').doc(documentId).set(data){
      //   'name': requestData['name'],
      //   'address': requestData['address'],
      //   'secretary_contact': requestData['secretary_contact'],
      // });
      FirebaseFirestore.instance.collection("Society").doc(documentId).set(
          {
            "id":documentId,
            "address":requestData['address'],
            "secretary_contact":requestData['secretary_contact'],
            "name":requestData['name']
          }).then((value){
        print('Data inserted');
      });
      FirebaseFirestore.instance.collection('SocietyRequest').doc(documentId).delete();


    } catch (e) {
      print("Error accepting request: $e");
    }
  }
}
