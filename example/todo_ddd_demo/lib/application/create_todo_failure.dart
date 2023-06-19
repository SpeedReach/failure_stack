import 'package:todo_ddd_demo/domain/repository_failure.dart';

sealed class CreateTodoFailure {}

class TodoRepositoryFailure extends CreateTodoFailure {
  final RepositoryFailure failure;

  TodoRepositoryFailure(this.failure);

  @override
  String toString() {
    return "An repository failure occurred $failure";
  }
}

class FormNotCompleteFailure extends CreateTodoFailure {
  final List<String> missing;

  FormNotCompleteFailure(this.missing);

  @override
  String toString() {
    return "You are missing the following fields $missing";
  }
}
