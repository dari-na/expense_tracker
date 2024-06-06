import 'package:expense_tracker/components/language_choose.dart';
import 'package:expense_tracker/OLD_screens/new_transaction.dart';
import 'package:expense_tracker/OLD_screens/transactions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../components/bottom_nav.dart';
import 'account.dart';
import 'annual.dart';
import 'budget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String selectedMonth = 'April';
  String selectedType = 'All types';

  Widget _buildPieChart() {
    return Center(
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: 74,
                color: Colors.orange,
                title: '74%',
              ),
              PieChartSectionData(
                value: 16,
                color: Colors.red,
                title: '16%',
              ),
              PieChartSectionData(
                value: 6,
                color: Colors.pink,
                title: '6%',
              ),
              PieChartSectionData(
                value: 4,
                color: Colors.blue,
                title: '4%',
              ),
            ],
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalAmount() {
    return const Center(
      child: Column(
        children: [
          Text(
            'Total',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '€579.74',
            style: TextStyle(fontSize: 24, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(
      String value, List<String> items, Null Function(dynamic value) param2) {
    return DropdownButton<String>(
      value: value,
      onChanged: (String? newValue) {
        setState(() {
          value = newValue!;
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

  Widget _buildSubCategoryExpense(String title, String date, String amount) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
          Text(date, style: TextStyle(fontSize: 14, color: Colors.grey)),
          Text(amount, style: TextStyle(fontSize: 14, color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildCategoryExpense(
      String category, String amount, Color color, double percent) {
    return GestureDetector(
      onTap: () {
        // Implement navigation to detailed view
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category, style: TextStyle(fontSize: 16)),
            Text(amount, style: TextStyle(fontSize: 16, color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryExpenses() {
    return Column(
      children: [
        _buildCategoryExpense('Home', '€430', Colors.orange, 0.8),
        _buildCategoryExpense('Subscription', '€22.98', Colors.blue, 0.5),
        _buildSubCategoryExpense('Spotify monthly', '12 April', '€9.99'),
        _buildSubCategoryExpense('Netflix monthly', '9 April', '€12.99'),
        _buildCategoryExpense('Groceries', '€92', Colors.red, 0.3),
        _buildCategoryExpense('Eating out', '€34.76', Colors.pink, 0.2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Expenser',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF4F518D),
          leading: IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              color: Colors.white,
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Account()),
                  )),
          actions: const [LanguageChoose(), SizedBox(width: 12)],
        ),
        bottomNavigationBar: BottomNav(
          currentIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
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
                  _buildDropdownButton(selectedMonth, ['April', 'May', 'June'],
                      (value) {
                    setState(() {
                      selectedMonth = value;
                    });
                  }),
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
              _buildCategoryExpenses(),
            ],
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TransactionsPage()));
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NewTransactionPage()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BudgetPage()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AnnualPage()));
        break;
    }

    void confirm() {}
  }
}
