import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../IDGenerator/IDGenerator.dart';

class FundLog extends StatefulWidget {
  final String? memberId;
  final String? societyId;
  const FundLog({super.key,required this.societyId,required this.memberId});

  @override
  State<FundLog> createState() => _FundLogState();
}

class _FundLogState extends State<FundLog> {
  String? _filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fund Log'),
        backgroundColor: HexColor("#8a76ba"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterButton(context, 'Pending', 'Pending'),
              _buildFilterButton(context, 'Paid', 'Paid'),
            ],
          ),
          Expanded(
            child: FundList(societyId: widget.societyId, filter: _filter),
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


class FundList extends StatelessWidget {
  final String? societyId;
  final String? filter;
  const FundList({super.key,required this.societyId,required this.filter});

  @override
  Widget build(BuildContext context) {
    print(societyId);
    Query query = FirebaseFirestore.instance
        .collection('Funds')
        .where('society_id', isEqualTo: societyId);

    if (filter != null && filter!.isNotEmpty) {
      query = query.where('status', isEqualTo: filter);
      // Add more filters here if needed
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
          return Center(child: Text('No funds available for this society'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data =
            docs[index].data() as Map<String, dynamic>;

            bool isPaid = data['status'] == 'Paid';

            return Card(
              child: ListTile(
                title: Text('Funds Id: ${data['id']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount: ${data['amount']}'),
                    Text('Date: ${data['date']}'),
                    Text('Status: ${data['status']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isPaid) // Render the "Paid" button only if the status is not paid
                      ElevatedButton(
                        onPressed: () async {
                          // Code to change status to "Paid"
                          await FirebaseFirestore.instance.collection('Funds').doc(data['id']).update({'status': 'Paid'});

                          // Code to add transaction to "Treasure" collection
                          String id = UniqueRandomStringGenerator.generateUniqueString(15);
                          await FirebaseFirestore.instance.collection("Treasure").doc(id).set({
                            'id': id,
                            'transaction_amount': 10000,
                            'transaction_type': 'Credit',
                            'transaction_description': 'Maintenance Bill',
                            'transaction_date': DateTime.now(),
                            'member_id': null,
                            'society_id': societyId
                          });
                        },
                        child: Text('Paid'),
                      ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Code for notification
                        // You can implement your notification logic here
                        // For example, showing a dialog or sending a notification
                      },
                      child: Text('Notify'),
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
}