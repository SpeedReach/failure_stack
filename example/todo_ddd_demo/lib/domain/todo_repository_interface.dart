


import 'package:result_stack/failure_stack.dart';
import 'package:todo_ddd_demo/domain/todo.dart';
import 'package:todo_ddd_demo/domain/repository_failure.dart';

abstract interface class TodoRepositoryInterface{

  ///Inserts the [todo] into the repository and returns its id
  Future<Result<String, RepositoryFailure>> createTodo(Todo todo);

  ///Get listed [Todo]s
  Future<Result<Todo, RepositoryFailure>> getTodo();



}