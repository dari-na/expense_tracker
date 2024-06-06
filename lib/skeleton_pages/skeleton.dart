import 'package:expense_tracker/components/top_nav.dart';
import 'package:expense_tracker/skeleton_pages/sk_annual.dart';
import 'package:expense_tracker/skeleton_pages/sk_budgets.dart';
import 'package:expense_tracker/skeleton_pages/sk_home.dart';
import 'package:expense_tracker/skeleton_pages/sk_new_trans.dart';
import 'package:expense_tracker/skeleton_pages/sk_trans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/bottom_nav.dart';
import 'kms_trans.dart';


class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  SkeletonState createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    SkHomePage(),
    SkTransPage(),
    SkBudgetsPage(),
    SkAnnualPage()
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SkNewTransactionPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index < 2 ? index : index - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNav(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex < 2 ? _selectedIndex : _selectedIndex + 1,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}