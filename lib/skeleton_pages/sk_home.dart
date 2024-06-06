import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/components/home_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../entities/categories.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SkHomePage extends StatefulWidget {
  const SkHomePage({super.key});

  @override
  _SkHomePageState createState() => _SkHomePageState();
}

class _SkHomePageState extends State<SkHomePage> {
  String selectedType = 'All types';
  DateTime selectedDate = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getSelectedMonth(DateTime selectedDate) {
    return DateFormat('MMMM').format(selectedDate);
  }

  Future<double> fetchBudgetAmount(String category, String month) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('budgets')
        .where('category', isEqualTo: category)
        .where('month', isEqualTo: selectedDate.month)
        .get();

    double totalBudget = 0.0;
    for (final doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      double budget = (data['totalAmount'] is String)
          ? double.parse(data['totalAmount'])
          : (data['totalAmount'] ?? 0).toDouble();
      totalBudget += budget;
    }
    return totalBudget;
  }

  Future<double> fetchSpentAmount(String category, DateTime selectedDate) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('transactions')
        .where('category', isEqualTo: category)
        .get();

    double totalSpent = 0.0;
    for (final doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Timestamp timestamp = data['timestamp'];
      DateTime transactionDate = timestamp.toDate();

      if (transactionDate.month == selectedDate.month &&
          transactionDate.year == selectedDate.year) {
        double spent = (data['amount'] is String)
            ? double.parse(data['amount'])
            : (data['amount'] ?? 0).toDouble();
        totalSpent += spent;
      }
    }
    return totalSpent;
  }

  Future<List<PieChartSectionData>> _getPieChartSections(List<String> categories) async {
    return Future.wait(categories.map((category) async {
      double spentAmount = await fetchSpentAmount(category, selectedDate);
      return PieChartSectionData(
        value: spentAmount,
        color: getCategoryColor(category),
        title: '$spentAmount',
      );
    }));
  }

  Future<List<Map<String, dynamic>>> _getCategoryExpenses(List<String> categories) async {
    String selectedMonth = getSelectedMonth(selectedDate);

    return Future.wait(categories.map((category) async {
      double spentAmount = await fetchSpentAmount(category, selectedDate);
      double budgetAmount = await fetchBudgetAmount(category, selectedMonth);
      double progress = budgetAmount != 0 ? spentAmount / budgetAmount : 0;
      return {
        'category': category,
        'spentAmount': spentAmount,
        'budgetAmount': budgetAmount,
        'progress': progress,
      };
    })).then((values) {
      values.sort((a, b) => (b['spentAmount'] as double).compareTo(a['spentAmount'] as double));
      return values;
    });
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            selectedDate = picked;
          });
        }
      },
      child: Text(
        DateFormat('dd MMM yyyy').format(selectedDate),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPieChart() {
    List<String> allCategories = getAllCategories();

    return FutureBuilder<List<PieChartSectionData>>(
      future: _getPieChartSections(allCategories),
      builder: (BuildContext context, AsyncSnapshot<List<PieChartSectionData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<PieChartSectionData> sections = snapshot.data ?? [];
          return SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                borderData: FlBorderData(show: false),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildTotalAmount() {
    List<String> allCategories = getAllCategories();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getCategoryExpenses(allCategories),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> data = snapshot.data ?? [];
          double totalSpent = data.fold(0.0, (sum, item) => sum + item['spentAmount']);
          List<Map<String, dynamic>> top3 = data.take(3).toList();
          return Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.total ?? 'Total',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '€${totalSpent.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 24, color: Color(0xFFC91825)),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              ...top3.map((item) {
                double percentage = totalSpent != 0 ? item['spentAmount'] / totalSpent * 100 : 0;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(getCategoryIcon(item['category']), color: getCategoryColor(item['category'])),
                        Text(
                          '  ${percentage.toStringAsFixed(2)}%',
                          style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ],
          );
        }
      },
    );
  }

  Widget _buildDropdownButton(
      String value, List<String> items, Null Function(dynamic value) param2) {
    return DropdownButton<String>(
      value: value,
      onChanged: (String? newValue) {
        setState(() {
          selectedType = newValue!;
        });
      },
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryExpenses() {
    List<String> allCategories = getAllCategories();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getCategoryExpenses(allCategories),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> data = snapshot.data ?? [];
          return Column(
            children: data.map((item) {
              return HomeCard(
                category: item['category'],
                spentAmount: item['spentAmount'],
                budgetAmount: item['budgetAmount'],
                progress: item['progress'],
                icon: getCategoryIcon(item['category']),
                color: getCategoryColor(item['category']),
              );
            }).toList(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 190,
              width: 308,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 190, width: 190, child: _buildPieChart()),
                  _buildTotalAmount()
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateSelector(),
                _buildDropdownButton(selectedType, [
                  'All types',
                  'Swedbank1',
                  'Swedbank2',
                  'Revolut',
                  'Cash'
                ], (value) {
                  setState(() {
                    selectedType = value;
                  });
                }),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(child: _buildCategoryExpenses()),
            ),
          ],
        ),
      ),
    );
  }

  void confirm() {}
}
