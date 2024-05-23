import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MemberList extends StatefulWidget {
  final String? memberId;
  final String? societyId;
  const MemberList({Key? key, required this.societyId, required this.memberId})
      : super(key: key);

  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member List'),
        backgroundColor: HexColor("#8a76ba"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Members...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: MemberCatalogue(
              societyId: widget.societyId,
              memberId: widget.memberId,
              searchQuery: _searchQuery,
            ),
          ),
        ],
      ),
    );
  }
}

class MemberCatalogue extends StatelessWidget {
  final String? memberId;
  final String? societyId;
  final String searchQuery;

  const MemberCatalogue({
    Key? key,
    required this.societyId,
    required this.memberId,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Members')
          .where('society', isEqualTo: societyId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final docs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final fullName = '${data['fname']} ${data['lname']}'.toLowerCase();
          return fullName.contains(searchQuery);
        }).toList();
        if (docs.isEmpty) {
          return const Center(child: Text('No members found.'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data =
            docs[index].data() as Map<String, dynamic>;
            return MemberCard(data: data);
          },
        );
      },
    );
  }
}

class MemberCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const MemberCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(
              data['fname'][0],
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: HexColor("#8a76ba"),
          ),
          title: Text('Member Id: ${data['id']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${data['fname']} ${data['lname']}'),
              Text('Contact: ${data['contact']}'),
              Text('E-mail: ${data['email']}'),
              Text('Designation: ${data['designation']}'),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _deleteMember(context, data['id']),
          ),
        ),
      ),
    );
  }

  void _deleteMember(BuildContext context, String memberId) {
    // Add logic here to delete the member with the given memberId from Firestore
    // For example:
    FirebaseFirestore.instance.collection('Members').doc(memberId).delete().then((value) {
      // Member deleted successfully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Member deleted successfully'),
      ));
    }).catchError((error) {
      // Error occurred while deleting member
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting member: $error'),
      ));
    });
  }
}