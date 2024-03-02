import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class ManageHouse extends StatefulWidget {
  final String? memberId;
  final String? societyId;
  const ManageHouse({super.key,this.memberId,required this.societyId});

  @override
  State<ManageHouse> createState() => _ManageHouseState();
}

class _ManageHouseState extends State<ManageHouse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: Text('Manage House'),
      ),
      body: HouseList(memberId: widget.memberId,),
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
    String house_id = '';
    String ownership = '';

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Add House'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value){
                      house_id = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter House No',
                      label: const Text('House No'),
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
                  TextField(
                    onChanged: (value){
                      ownership = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Ownership Type',
                      label: const Text('Ownership'),
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
                    await FirebaseFirestore.instance.collection("House").doc(house_id).set(
                        {
                          'id' : house_id,
                          'member_id' : memberId,
                          'ownership' : ownership,
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

class HouseList extends StatelessWidget {
  final String? memberId;
  const HouseList({super.key,this.memberId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('House')
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
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data =
            docs[index].data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text('House No: ${data['id']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ownership Type: ${data['ownership']}'),
                    Text('Society Name: ${data['society_id']}'),
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
      FirebaseFirestore.instance.collection('House').doc(id).delete();
      // Optional: Show a snackbar or message to indicate successful deletion
    } catch (e) {
      print("Error deleting document: $e");
      // Handle delete errors here
    }
  }
}
