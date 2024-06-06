import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/entities/categories.dart';
import 'package:expense_tracker/skeleton_pages/sk_new_budget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/budget_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' as L;


class SkBudgetsPage extends StatefulWidget {
  const SkBudgetsPage({super.key});

  @override
  SkBudgetsPageState createState() => SkBudgetsPageState();
}

class SkBudgetsPageState extends State<SkBudgetsPage> {
  DateTime selectedDate = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Map<String, dynamic>>> _budgets;

  @override
  void initState() {
    super.initState();
    _budgets = _fetchBudgets();
  }

  Future<List<Map<String, dynamic>>> _fetchBudgets() async {
    QuerySnapshot querySnapshot = await _firestore.collection('budgets')
        .where('month', isEqualTo: selectedDate.month)
        .where('year', isEqualTo: selectedDate.year)
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }



  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: () {
            setState(() {
              selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
              _budgets = _fetchBudgets();
            });
          },
        ),
        Text(
          "${DateFormat('MMMM yyyy').format(selectedDate)}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: () {
            setState(() {
              selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
              _budgets = _fetchBudgets();
            });
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
            MaterialPageRoute(builder: (context) => const SkNewBudgetPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4F518D),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        child: Text(
          L.AppLocalizations.of(context)!.new_budget ?? 'New budget',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildMonthSelector(),
            SizedBox(height: 12),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _budgets = _fetchBudgets();
                    });
                  },
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _budgets,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text(L.AppLocalizations.of(context)!.no_budgets ?? 'No budgets');
                      } else {
                        return ListView(
                            children: snapshot.data!.map((budget) {
                              return BudgetCard(
                              icon: getCategoryIcon(budget['category'] ?? ''),
                              category: budget['category'] ?? '',
                              totalAmount: budget['totalAmount']?.toDouble() ?? 0.0,
                              color: getCategoryColor(budget['category'] ?? ''),
                              );
                            }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ),
            const Spacer(),
            _buildNewBudgetButton(),
          ],
        ),
      ),
    );
  }


    void confirm() {}
  }
