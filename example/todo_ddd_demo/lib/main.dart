import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_ddd_demo/domain/todo_repository_interface.dart';
import 'package:todo_ddd_demo/infrastructure/todo_repository.dart';
import 'package:todo_ddd_demo/presentation/todo_page.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TodoRepositoryInterface>(
      create: (_)=> TodoRepository(),
      child: const MaterialApp(
        home: TodoPage(),
      ),
    );
  }
}