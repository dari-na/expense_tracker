import 'package:expense_tracker/entities/categories.dart';
import 'package:expense_tracker/entities/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/cur_cus_switch.dart';
import '../entities/transaction.dart';
//import '../.dart_tool/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SkNewTransactionPage extends StatefulWidget {
  const SkNewTransactionPage({super.key});

  @override
  SkNewTransactionPageState createState() => SkNewTransactionPageState();
}

class SkNewTransactionPageState extends State<SkNewTransactionPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _selectedCategory = 'Eating out';
  String _selectedPaymentMethod = 'Swedbank';
  bool _isCustomTimestamp = false;

  Future<void> _addTransaction() async {
    final String _emptyMessage = AppLocalizations.of(context)?.error_empty_fields ?? '';
    final String _successMessage = AppLocalizations.of(context)?.success_new_trans?? '';
    final amount = _amountController.text.trim();
    final title = _titleController.text.trim();
    if (amount.isEmpty || title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text(_emptyMessage, style: const TextStyle(color: Colors.white),)),
      );
      return;
    }
    try {
      Timestamp timestamp;
      if (_isCustomTimestamp) {
        final date = _dateController.text;
        final dateParts = date.split('-');
        final year = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);
        timestamp = Timestamp.fromDate(DateTime(year, month, day));
      } else {
        timestamp = Timestamp.now();
      }

      final transaction = Trans(
        amount: _amountController.text,
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        paymentMethod: _selectedPaymentMethod,
        timestamp: timestamp,
      );

      await FirebaseFirestore.instance
          .collection('transactions')
          .add(transaction.toJson());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_successMessage), backgroundColor: const Color(0xFF6aa84f),),
      );
      Navigator.pop(context);
    } catch (e) {
      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding transaction: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.new_trans_title ??'New Transaction',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF4F518D),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.amount ?? 'Amount',
                prefixText: '€',
              ),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.title ?? 'Title',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.description ?? 'Description',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)?.category ?? 'Category', style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 180,
                  height: 60,
                  child: DropdownButtonFormField(
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    items: categories.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)?.payment ?? 'Payment', style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 180,
                  height: 60,
                  child: DropdownButtonFormField(
                    value: _selectedPaymentMethod,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPaymentMethod = newValue!;
                      });
                    },
                    items: paymentMethods.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)?.timestamp ?? 'Timestamp', style: TextStyle(fontSize: 16)),
                CustomSwitch(
                  value: _isCustomTimestamp,
                  onChanged: (bool newValue) {
                    setState(() {
                      _isCustomTimestamp = newValue;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: _isCustomTimestamp,
              child: TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4F518D)),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context)
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _addTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F518D),
                ),
                child: Text(AppLocalizations.of(context)?.add_transaction ?? 'Add transaction', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().substring(0, 10);
      });
    }
  }

}