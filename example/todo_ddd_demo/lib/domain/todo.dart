

import 'package:flutter/material.dart';

class Todo{
  final String title;
  final String description;

  Todo({
    required this.title,
    required this.description,
  });

  factory Todo.fromJson(Map<String,dynamic> json) =>
      Todo(
          title: json["title"],
          description: json["description"],
      );

}