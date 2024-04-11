import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HouseData extends StatefulWidget {
  final String? societyId;
  const HouseData({Key? key, required this.societyId}) : super(key: key);

  @override
  _HouseDataState createState() => _HouseDataState();
}

class _HouseDataState extends State<HouseData> {
  String? _filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('House List'),
        backgroundColor: HexColor("#8a76ba"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterButton(context, 'Owned', 'Owned'),
              _buildFilterButton(context, 'Rented', 'Rented'),
              _buildFilterButton(context, 'To be Rented', 'to_be_rented'),
            ],
          ),
          Expanded(
            child: HouseCatalogue(societyId: widget.societyId, filter: _filter),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String label, String filter) {
    bool isSelected = _filter == filter;
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Filtering by $label'),
            duration: Duration(seconds: 1),
          ),
        );
        setState(() {
          _filter = isSelected ? null : filter;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : null, backgroundColor: isSelected ? Colors.black : null,
      ),
      child: Text(label),
    );
  }
}

class HouseCatalogue extends StatelessWidget {
  final String? societyId;
  final String? filter;

  const HouseCatalogue({Key? key, required this.societyId, this.filter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('House')
        .where('society_id', isEqualTo: societyId);

    if (filter != null && filter!.isNotEmpty) {
      query = query.where('ownership', isEqualTo: filter);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
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