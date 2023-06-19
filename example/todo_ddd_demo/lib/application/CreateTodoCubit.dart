


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_stack/failure_stack.dart';
import 'package:todo_ddd_demo/application/CreateTodoFailure.dart';
import 'package:todo_ddd_demo/application/CreateTodoForm.dart';
import 'package:todo_ddd_demo/domain/todo.dart';
import 'package:todo_ddd_demo/domain/todo_repository_interface.dart';

class CreateTodoCubit extends Cubit<CreateTodoForm>{

  final TodoRepositoryInterface repository;

  CreateTodoCubit(this.repository): super(const CreateTodoForm(title: "", description: ""));



  void setTitle(String title) => emit(state.copyWith(title: title));


  void setDescription(String description)=> emit(state.copyWith(description: description));


  Future<Result<String, CreateTodoFailure>> createTodo() async {
    ///With the [asyncResultHandleEnvironment] results with type [Result<dynamic, CreateTodoFailure>] can be safely unwrapped directly with elegant syntax
    return asyncResultHandleEnvironment(() async {

      ///If the form has the following field empty , returns [FormNotCompleteFailure]
      List<String> missingFields = [];
      if(state.description.isEmpty) missingFields.add("description");
      if(state.title.isEmpty) missingFields.add("title");
      if(missingFields.isNotEmpty) return Fail(FormNotCompleteFailure(missingFields));

      final result = await repository.createTodo(Todo(
          title: state.title,
          description: state.description,
      ));

      ///We can directly unwrap here because [asyncResultHandleEnvironment] handles the thrown [FailureStack<CreateTodoFailure>] for us.
      final todoId = result.mapFail((failure) => TodoRepositoryFailure(failure)).unwrap();
      
      return Ok(todoId);
    });
  }

}