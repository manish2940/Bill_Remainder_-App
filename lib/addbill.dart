import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bill_provider.dart';
import 'bill.dart';

class AddBillScreen extends StatefulWidget {
  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _amount = 0;
  DateTime _dueDate = DateTime.now();
  String _vendorUPI = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Bill Name'),
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _amount = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Vendor UPI ID'),
                onSaved: (value) => _vendorUPI = value!,
              ),
              ElevatedButton(
                onPressed: _pickDueDate,
                child: Text('Pick Due Date'),
              ),
              ElevatedButton(
                onPressed: _saveBill,
                child: Text('Save Bill'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }

  void _saveBill() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final bill = Bill(
        name: _name,
        amount: _amount,
        dueDate: _dueDate,
        vendorUPI: _vendorUPI,
      );
      Provider.of<BillProvider>(context, listen: false).addBill(bill);
      Navigator.pop(context);
    }
  }
}
