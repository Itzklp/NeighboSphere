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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton(context, 'Owned', 'Owned'),
                _buildFilterButton(context, 'Rented', 'Rented'),
                _buildFilterButton(context, 'To be Rented', 'To be Rented'),
              ],
            ),
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
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Filtering by $label'),
            duration: const Duration(seconds: 1),
          ),
        );
        setState(() {
          _filter = isSelected ? null : filter;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black, backgroundColor: isSelected ? Colors.black : Colors.grey[300],
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
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
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('Society has no houses'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data =
            docs[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
