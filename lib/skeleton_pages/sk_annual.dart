import 'package:expense_tracker/OLD_screens/transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/budget_card.dart';
import '../components/old_bc.dart';

class SkAnnualPage extends StatefulWidget {
  const SkAnnualPage({super.key});

  @override
  SkAnnualPageState createState() => SkAnnualPageState();
}

class SkAnnualPageState extends State<SkAnnualPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: OldBudgetCard(
            category: 'Eating out',
            totalAmount: 100.0,
            icon: Icons.restaurant,
            color: Colors.pink,
          ),
        ),
      );
  }

    void confirm() {}

  }
