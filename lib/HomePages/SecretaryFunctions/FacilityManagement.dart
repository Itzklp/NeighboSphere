import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../IDGenerator/IDGenerator.dart';

class FacilityManagement extends StatefulWidget {
  final String? memberId;
  final String? societyId;
  const FacilityManagement({super.key,required this.memberId,required this.societyId});

  @override
  State<FacilityManagement> createState() => _FacilityManagementState();
}

class _FacilityManagementState extends State<FacilityManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: Text('Facility'),
      ),
      body: FacilityList(memberId: widget.memberId,societyId: widget.memberId,),
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
    String describe = '';

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Add Facility'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value){
                      describe = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Facility Description',
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
                    await FirebaseFirestore.instance.collection("Facility").doc(id).set(
                        {
                          'id' : id,
                          'description' : describe,
                          'society_id' : societyId
                        });
                    Navigator.of(context).pop();
                  });

                },
                child: Text('Add'),
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

class FacilityList extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const FacilityList({super.key,required this.societyId,required this.memberId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Facility')
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
          return Center(child: Text('You have no facility.'));
        }
        print(docs);
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data =
            docs[index].data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text('Facility Id: ${data['id']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Facility Description: ${data['description']}'),
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
      FirebaseFirestore.instance.collection('Facility').doc(id).delete();
      // Optional: Show a snackbar or message to indicate successful deletion
    } catch (e) {
      print("Error deleting document: $e");
      // Handle delete errors here
    }
  }
}
