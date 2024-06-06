import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransCard extends StatelessWidget {
  final String category;
  final IconData icon;
  final Color color;
  final double amount;
  final String title;
  final String timestamp;
  final String paymentMethod;

  const TransCard(
      {super.key,
      required this.category,
      required this.amount,
      required this.icon,
      required this.color,
      required this.title,
      required this.timestamp,
      required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
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
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    timestamp,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(width: 10),
            Column(
              children: [
                Text(
                  '€${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFC91825)
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  paymentMethod,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
