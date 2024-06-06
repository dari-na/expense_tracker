import 'package:expense_tracker/OLD_screens/transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/bottom_nav.dart';
import '../components/language_choose.dart';
import 'account.dart';
import 'budget.dart';
import 'home.dart';
import 'new_transaction.dart';

class AnnualPage extends StatefulWidget {
  const AnnualPage({super.key});

  @override
  AnnualPageState createState() => AnnualPageState();
}

class AnnualPageState extends State<AnnualPage> {
  int _selectedIndex = 4;

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
            MaterialPageRoute(builder: (context) => const TransactionsPage()));
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
        break;
    }

    void confirm() {}
  }

}