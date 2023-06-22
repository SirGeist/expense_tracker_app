import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

// Predefined allowed values
// Not necessarilly strings
enum Category { food, travel, leisure, work }

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
}
