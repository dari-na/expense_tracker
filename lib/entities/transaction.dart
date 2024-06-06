import 'package:cloud_firestore/cloud_firestore.dart';

class Trans {
  final String amount;
  final String title;
  final String? description;
  final String category;
  final String paymentMethod;
  final Timestamp timestamp;

  Trans({
    required this.amount,
    required this.title,
    this.description,
    required this.category,
    required this.paymentMethod,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'title': title,
    'description': description,
    'category': category,
    'paymentMethod': paymentMethod,
    'timestamp': timestamp,
  };

  factory Trans.fromJson(Map<String, dynamic> json) => Trans(
    amount: json['amount'],
    title: json['title'],
    description: json['description'],
    category: json['category'],
    paymentMethod: json['paymentMethod'],
    timestamp: json['timestamp']
  );
}