import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();

// Storing Utility class used to format dates
final formatter = DateFormat.yMd();

// Predefined allowed values
// Not necessarilly strings
enum Category { food, travel, leisure, work }

// Keys are the enum with their respective icon
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  // Constructor
  // id... is an Initializer list: used to initialize class properties with values
  // that are not received as constructor function arguments
  //
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid
            .v4(); // generates a unique id and assigns it as an additional value

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  // Using "Getters" which are computed properties that are dynamically
  // derived based on other class properties
  // Using intl package for easier date formatting

  String get formattedDate{
    return formatter.format(date);
  }
}
