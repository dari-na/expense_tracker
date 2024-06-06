import 'dart:ui';

import 'package:flutter/material.dart';

List<String> categories = [
  'Eating out',
  'Groceries',
  'Home',
  'Subscriptions',
  'Transport',
  'Entertainment'
];

Color getCategoryColor(String category) {
  switch (category) {
    case 'Eating out':
      return Color(0xffCA498C);
    case 'Subscriptions':
      return Color(0xff2079CB);
    case 'Groceries':
      return Color(0xffF87B7B);
    case 'Transport':
      return Color(0xff46CB83);
    case 'Entertainment':
      return Color(0xff9260D2);
    case 'Home':
      return Color(0xffFFC14A);
  }
  return Colors.grey;
}

IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Eating out':
      return Icons.restaurant;
    case 'Subscriptions':
      return Icons.subscriptions;
    case 'Groceries':
      return Icons.shopping_cart;
    case 'Transport':
      return Icons.directions_bus;
    case 'Entertainment':
      return Icons.movie;
    case 'Home':
      return Icons.home_outlined;}
  return Icons.category;}

List<String> getAllCategories() {
  return categories;
}

enum Category {
  eatingOut,
  subscriptions,
  groceries,
  transport,
  entertainment,
  home,
}

final Map<Category, Color> categoryColors = {
  Category.eatingOut: Color(0xffCA498C),
  Category.subscriptions: Color(0xff2079CB),
  Category.groceries: Color(0xffF87B7B),
  Category.transport: Color(0xff46CB83),
  Category.entertainment: Color(0xff9260D2),
  Category.home: Color(0xffFFC14A),
};
