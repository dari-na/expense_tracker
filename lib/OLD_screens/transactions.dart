import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../components/bottom_nav.dart';
import '../components/language_choose.dart';
import 'account.dart';
import 'annual.dart';
import 'budget.dart';
import 'home.dart';
import 'new_transaction.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  TransactionsPageState createState() => TransactionsPageState();
}

class TransactionsPageState extends State<TransactionsPage> {
  String selectedPeriod = 'Today';
  String selectedDate = '11 May 2024';
  int _selectedIndex = 1;

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
              MaterialPageRoute(
                  builder: (context) => const Account()),
            )),
        actions: const [LanguageChoose(), SizedBox(width: 12)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  // Implement date picker here
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    selectedDate,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 2,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 3),
                        FlSpot(2, 2),
                        FlSpot(3, 4),
                        FlSpot(4, 3),
                      ],
                      isCurved: true,
                      color: Color(0xFF4F518D),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPeriodButton('Today'),
                _buildPeriodButton('Week'),
                _buildPeriodButton('Month'),
                _buildPeriodButton('Year'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Implement filter functionality here
                  },
                  child: Text('See All'),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: _buildTransactionList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = period;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedPeriod == period ? Color(0xFF4F518D) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          period,
          style: TextStyle(
            color: selectedPeriod == period ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTransactionList() {
    return [
      _buildTransactionItem('Rent', '€320', '11 May, 23:16', 'Swedbank', Icons.home, Colors.orange),
      _buildTransactionItem('Spotify', '€9.99', '11 May, 18:55', 'Revolut', Icons.music_note, Colors.blue),
      _buildTransactionItem('Pizza Maks', '€11.50', '11 May, 18:43', 'Cash', Icons.fastfood, Colors.pink),
      _buildTransactionItem('Rimi', '€43.67', '11 May, 10:26', 'Swedbank', Icons.shopping_cart, Colors.red),
    ];
  }

  Widget _buildTransactionItem(String title, String amount, String date, String method, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(date),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(amount, style: TextStyle(color: Colors.red)),
            Text(method),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 1:
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

  }
}
