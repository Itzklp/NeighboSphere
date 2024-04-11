import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import '../../IDGenerator/IDGenerator.dart';

class TransactionLog extends StatefulWidget {
  final String? memberId;
  final String? societyId;
  const TransactionLog({super.key,required this.societyId,required this.memberId});

  @override
  State<TransactionLog> createState() => _TransactionLogState();
}

class _TransactionLogState extends State<TransactionLog> {
  String? _filter;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction List'),
        backgroundColor: HexColor("#8a76ba"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterButton(context, 'Credit', 'Credit'),
              _buildFilterButton(context, 'Debit', 'Debit'),
            ],
          ),
          Expanded(
            child: TransactionList(societyId: widget.societyId, filter: _filter),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            _addTransaction(context,widget.societyId,widget.memberId);
          }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  void _addTransaction(BuildContext context, String? societyId, String? memberId) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String transactionAmount = '';
        String transactionType = 'Credit';
        String transactionDescription = '';
        DateTime transactionDate = DateTime.now();

        return AlertDialog(
          title: const Text('Add Transaction'),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      transactionAmount = value;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Transaction Amount',
                      label: const Text('Transaction Amount'),
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
                  SizedBox(height: 15.0),
                  DropdownButtonFormField<String>(
                    value: transactionType,
                    onChanged: (String? value) { // Change the parameter type to nullable
                      if(value != null) { // Check if the value is not null
                        setState(() {
                          transactionType = value;
                        });
                      }
                    },
                    items: ['Credit', 'Debit']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Transaction Type',
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
                  SizedBox(height: 15.0),
                  TextField(
                    onChanged: (value) {
                      transactionDescription = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Transaction Description',
                      label: const Text('Transaction Description'),
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
                  SizedBox(height: 15.0),
                  TextField(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          transactionDate = picked;
                        });
                      }
                    },
                    readOnly: true,
                    controller: TextEditingController(
                        text: transactionDate == null
                            ? ''
                            : DateFormat('yyyy-MM-dd').format(transactionDate)),
                    decoration: InputDecoration(
                      hintText: 'Select Transaction Date',
                      label: const Text('Transaction Date'),
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
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (transactionAmount.isNotEmpty &&
                    transactionDescription.isNotEmpty &&
                    transactionDate != null) {
                  setState(() async {
                    String id = UniqueRandomStringGenerator.generateUniqueString(15);
                    await FirebaseFirestore.instance.collection("Treasure").doc(id).set({
                      'id': id,
                      'transaction_amount': transactionAmount,
                      'transaction_type': transactionType,
                      'transaction_description': transactionDescription,
                      'transaction_date': transactionDate,
                      'member_id': memberId,
                      'society_id': societyId
                    });
                    Navigator.of(context).pop();
                  });
                } else {
                  // Show some error message or handle validation
                }
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );

  }
}

class TransactionList extends StatelessWidget {
  final String? societyId;
  final String? filter;

  const TransactionList({Key? key, required this.societyId, this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('Treasure').where('society_id', isEqualTo: societyId);

    if (filter != null && filter!.isNotEmpty) {
      query = query.where('transaction_type', isEqualTo: filter);
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
          return Center(child: Text('No Transactions available'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text('Transaction Id: ${data['id']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount: ${data['transaction_amount']}'),
                    Text('Type: ${data['transaction_type']}'),
                    Text('Description: ${data['transaction_description']}'),
                    Text('Date: ${DateFormat('yyyy-MM-dd').format(data['transaction_date'].toDate())}'),
                    Text('Society Name: ${data['society_id']}'),
                    Text('Member Name: ${data['member_id']}'),
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




