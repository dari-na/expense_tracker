import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/components/top_nav.dart';
import 'package:expense_tracker/entities/categories.dart';
import 'package:expense_tracker/OLD_screens/transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/bottom_nav.dart';
import '../components/old_bc.dart';
import '../components/language_choose.dart';
import 'account.dart';
import 'annual.dart';
import 'home.dart';
import 'new_budget.dart';
import 'new_transaction.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  BudgetPageState createState() => BudgetPageState();
}

class BudgetPageState extends State<BudgetPage> {
  int _selectedIndex = 3;
  String selectedMonthYear = 'May 2024';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Map<String, dynamic>>> _budgets;

  @override
  void initState() {
    super.initState();
    _budgets = _fetchBudgets();
  }

  Future<List<Map<String, dynamic>>> _fetchBudgets() async {
    QuerySnapshot querySnapshot = await _firestore.collection('budgets').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: () {
            // Implement month change logic
          },
        ),
        Text(
          selectedMonthYear,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: () {
            // Implement month change logic
          },
        ),
      ],
    );
  }

  Widget _buildNewBudgetButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewBudgetPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4F518D),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        child: Text(
          'New budget',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNav(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMonthSelector(),
            SizedBox(height: 20),
            SingleChildScrollView(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _budgets,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No budgets found');
                  } else {
                    return Expanded(
                      child: ListView(
                        children: snapshot.data!.map((budget) {
                          return OldBudgetCard(
                            icon: getCategoryIcon(budget['category']),
                            category: budget['category'],
                            totalAmount: budget['total'].toDouble(),
                            color: getCategoryColor(budget['category']),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ),
             const Spacer(),
            _buildNewBudgetButton(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
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
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AnnualPage()));
        break;
    }



    void confirm() {}
  }

}