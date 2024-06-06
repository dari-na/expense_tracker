import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/entities/categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';
import '../components/trans_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SkTransPage extends StatefulWidget {
  const SkTransPage({super.key});

  @override
  SkTransPageState createState() => SkTransPageState();
}

class SkTransPageState extends State<SkTransPage> {
  DateTime selectedDate = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Map<String, dynamic>>> _transactions;
  String selectedPeriod = 'Today';

  @override
  void initState() {
    super.initState();
    _transactions = _fetchTransactions();
  }

  Future<List<Map<String, dynamic>>> _fetchTransactions() async {
    DateTime start = DateTime.now();
    DateTime end = DateTime.now();

    if (selectedPeriod == 'Today') {
      start = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
      end = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);
    } else if (selectedPeriod == 'Week') {
      // Start of the week is the previous Monday
      start = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
      start = DateTime(
          start.year, start.month, start.day, 0, 0, 0); // Start of the day

      // End of the week is the next Sunday
      end = selectedDate.add(Duration(days: 7 - selectedDate.weekday));
      end =
          DateTime(end.year, end.month, end.day, 23, 59, 59); // End of the day
    } else if (selectedPeriod == 'Month') {
      start = DateTime(selectedDate.year, selectedDate.month, 1, 0, 0, 0);
      end = DateTime(selectedDate.year, selectedDate.month + 1, 0, 23, 59, 59);
    }

    Timestamp startTimestamp = Timestamp.fromDate(start);
    Timestamp endTimestamp = Timestamp.fromDate(end);

    QuerySnapshot querySnapshot = await _firestore
        .collection('transactions')
        .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
        .where('timestamp', isLessThanOrEqualTo: endTimestamp)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  List<FlSpot> _generateChartData(List<Map<String, dynamic>> transactions) {
    // Sort the transactions by timestamp
    transactions.sort((a, b) =>
        (a['timestamp'] as Timestamp).compareTo(b['timestamp'] as Timestamp));

    // Initialize an empty list of spots
    List<FlSpot> spots = [];

    // Iterate over the transactions and add a spot for each one
    for (int i = 0; i < transactions.length; i++) {
      double x = i.toDouble();
      double y = double.parse(transactions[i]['amount'] ?? '0.0');
      spots.add(FlSpot(x, y));
    }

    return spots;
  }

  Widget _buildLineChart(List<FlSpot> spots) {
    return Container(
      height: 130,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
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
            _transactions = _fetchTransactions();
          });
        }
      },
      child: Text(
        DateFormat('dd MMM yyyy').format(selectedDate),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    String localizedPeriod = '';
    switch (period) {
      case 'Today':
        localizedPeriod = AppLocalizations.of(context)?.today ?? 'Today';
        break;
      case 'Week':
        localizedPeriod = AppLocalizations.of(context)?.week ?? 'Week';
        break;
      case 'Month':
        localizedPeriod = AppLocalizations.of(context)?.month ?? 'Month';
        break;
      default:
        localizedPeriod = period;
    }

    Color buttonColor =
        period == selectedPeriod ? Color(0xff4F518D) : Colors.white;
    Color textColor =
        period == selectedPeriod ? Colors.white : Color(0xff4F518D);

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
        ),
        onPressed: () {
          setState(() {
            selectedPeriod = period;
            _transactions = _fetchTransactions();
          });
        },
        child: Text(localizedPeriod, style: TextStyle(color: textColor)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        child: Column(
          children: [
            _buildDateSelector(),
            SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No transactions found');
                } else {
                  List<FlSpot> chartData = _generateChartData(snapshot.data!);
                  return _buildLineChart(chartData);
                }
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPeriodButton('Today'),
                _buildPeriodButton('Week'),
                _buildPeriodButton('Month')
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _transactions = _fetchTransactions();
                    });
                  },
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchTransactions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No transactions found');
                      } else {
                        return ListView(
                          children: snapshot.data!.map((transaction) {
                            Timestamp timestamp = transaction['timestamp'];
                            String formattedDate = DateFormat('dd MMM yyyy')
                                .format(timestamp.toDate());
                            double amount =
                                double.parse(transaction['amount'] ?? '0.0');

                            return TransCard(
                              icon: getCategoryIcon(
                                  transaction['category'] ?? ''),
                              category: transaction['category'] ?? '',
                              amount: amount,
                              color: getCategoryColor(
                                  transaction['category'] ?? ''),
                              title: transaction['title'] ?? '',
                              timestamp: formattedDate,
                              paymentMethod: transaction['paymentMethod'] ?? '',
                            );
                          }).toList(),
                        );
                      }
                    },
                  )),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void confirm() {}
}
