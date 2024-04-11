import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../IDGenerator/IDGenerator.dart';

class AddVisitor extends StatefulWidget {
  final String? memberId;
  final String? societyId;
  const AddVisitor({super.key,required this.societyId,required this.memberId});

  @override
  State<AddVisitor> createState() => _AddVisitorState();
}

class _AddVisitorState extends State<AddVisitor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#8a76ba"),
        title: Text('Add Expected Visitor'),
      ),
      body: AddedList(memberId: widget.memberId,societyId: widget.societyId,),
      floatingActionButton: FloatingActionButton(
        child: Icon(
            Icons.add
        ),
        onPressed: _addVisitor(context,widget.societyId,widget.memberId),
        backgroundColor: HexColor('#8a76ba'),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _addVisitor(BuildContext context,String? societyId,String? memberId) {
    String name = '';
    String contact = '';
    String purpose = '';
    String house_no = '';
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Add Visitor'),
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        name = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Visitor Name',
                        label: const Text('Name'),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8a76ba")),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor("#8a76ba"),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    TextField(
                      onChanged: (value) {
                        contact = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter Visitor Contact',
                        label: const Text('Contact'),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8a76ba")),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor("#8a76ba"),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    TextField(
                      onChanged: (value) {
                        house_no = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter House To Be Visited',
                        label: const Text('House No'),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8a76ba")),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor("#8a76ba"),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    TextField(
                      onChanged: (value) {
                        purpose = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Visiting Purpose',
                        label: const Text('Purpose'),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#8a76ba")),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor("#8a76ba"),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                  ],
                ),
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
                    DateTime now = DateTime.now();
                    String id = UniqueRandomStringGenerator.generateUniqueString(15);
                    await FirebaseFirestore.instance.collection("Visitor").doc(id).set(
                        {
                          'id' : id,
                          'house_no' : house_no,
                          'name' : name,
                          'society_id' : societyId,
                          'contact' : contact,
                          'date' : '${now}',
                          'purpose' : purpose,
                        });
                    Navigator.of(context).pop();
                  });

                },
                child: Text('Submit'),
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

class AddedList extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  const AddedList({Key? key, required this.memberId, required this.societyId}) : super(key: key);

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
                    .collection('ExpectedVisitor')
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