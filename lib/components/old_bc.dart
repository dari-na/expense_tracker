import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OldBudgetCard extends StatelessWidget {
  final String category;
  final double totalAmount;
  final IconData icon;
  final Color color;

  const OldBudgetCard(
      {super.key,
        required this.category,
        required this.totalAmount,
        required this.icon,
        required this.color});

  Future<double> fetchSpentAmount() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('category', isEqualTo: category)
        .get();
    double totalSpent = 0.0;

    for (final doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      double spent = (data['amount'] is String) ? double.parse(data['amount']) : (data['amount'] ?? 0).toDouble();
      totalSpent += spent;
    }

    return totalSpent;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: fetchSpentAmount(),
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            double spentAmount = snapshot.data ?? 0.0;
            double remainingAmount = totalAmount - spentAmount;
            int weeksInMonth = DateTime.now().day ~/ 7;
            double amountPerWeek = totalAmount / 4;
            double progress = totalAmount != 0 ? spentAmount / totalAmount : 0;

            return Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: color, size: 30),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Remaining €${remainingAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '€${amountPerWeek.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'per week',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(3),
                        ),

                      SizedBox(height: 5),
                      Text(
                        '€${spentAmount.toStringAsFixed(2)} out of €${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),],
                    ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
