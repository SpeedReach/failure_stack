


import 'package:dio/dio.dart';
import 'package:result_stack/failure_stack.dart';
import 'package:todo_ddd_demo/domain/repository_failure.dart';
import 'package:todo_ddd_demo/domain/todo.dart';
import 'package:todo_ddd_demo/domain/todo_repository_interface.dart';
import 'package:todo_ddd_demo/infrastructure/error_adapter.dart';

class TodoRepository implements TodoRepositoryInterface{
  
  final Dio dio = Dio();
  final String url = "localhost:8080/";
  
  @override
  Future<Result<String, RepositoryFailure>> createTodo(Todo todo) async {
    try{
      var res = await dio.post("$url/todo");
      return Ok(res.data["id"]);
    }
    on DioException catch(e){
      return Fail(e.intoRepositoryFailure());
    }
  }

  @override
  Future<Result<Todo, RepositoryFailure>> getTodo() async {
    try{
      var response =  await dio.get("$url/todo");
      return Ok(Todo.fromJson(response.data));
    }
    on DioException catch(e){
      return Fail(e.intoRepositoryFailure());
    }
  }

}