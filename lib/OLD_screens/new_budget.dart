import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../entities/categories.dart';

class NewBudgetPage extends StatefulWidget {
  const NewBudgetPage({super.key});

  @override
  _NewBudgetPageState createState() => _NewBudgetPageState();
}

class _NewBudgetPageState extends State<NewBudgetPage> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Groceries';
  bool _isWeekly = true;
  bool _setAlert = false;
  double _alertPercentage = 75;
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4F518D),
        title: Text(
            AppLocalizations.of(context)?.new_budget ?? 'New Budget',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '€',
                ),
                style: TextStyle(fontSize: 40, color: Color(0xFF4F518D)),
              ),
              const SizedBox(height: 20),
              Text('Category', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
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
              const SizedBox(height: 20),
              Text('Timespan', style: TextStyle(fontSize: 18)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ChoiceChip(
                    label: Text('Week'),
                    selected: _isWeekly,
                    onSelected: (bool selected) {
                      setState(() {
                        _isWeekly = selected;
                      });
                    },
                    selectedColor: Color(0xFF4F518D),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('Month'),
                    selected: !_isWeekly,
                    onSelected: (bool selected) {
                      setState(() {
                        _isWeekly = !selected;
                      });
                    },
                    selectedColor: Color(0xFF4F518D),
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Set alert', style: TextStyle(fontSize: 18)),
              SwitchListTile(
                title: Text('Alert when spending reaches ${_alertPercentage.toInt()}%'),
                value: _setAlert,
                onChanged: (bool value) {
                  setState(() {
                    _setAlert = value;
                  });
                },
              ),
              Visibility(
                visible: _setAlert,
                child: Slider(
                  value: _alertPercentage,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: '${_alertPercentage.toInt()}%',
                  onChanged: (double value) {
                    setState(() {
                      _alertPercentage = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text('Month', style: TextStyle(fontSize: 18)),
              ListTile(
                title: Text('${_selectedMonth.month}-${_selectedMonth.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _selectMonth,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveBudget,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4F518D),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('Add new budget', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectMonth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF4F518D), //Header background color
            hintColor: Color(0xFF4F518D), //Header text color
            colorScheme: ColorScheme.light(primary: Color(0xFF4F518D)),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedMonth)
      setState(() {
        _selectedMonth = picked;
      });
  }

  Future<void> _saveBudget() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final totalAmount = _isWeekly ? amount * 4 : amount;

    final budgetData = {
      'category': _selectedCategory,
      'totalAmount': totalAmount,
      'alert': _setAlert,
      'alertPercentage': _alertPercentage,
      'month': _selectedMonth.month,
      'year': _selectedMonth.year,
    };

    // Save to Firestore
    await FirebaseFirestore.instance.collection('budgets').add(budgetData);

    // Navigate back
    Navigator.of(context).pop();
  }
}
