import 'package:equatable/equatable.dart';

class CreateTodoForm extends Equatable {
  final String title;
  final String description;

  const CreateTodoForm({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];

  CreateTodoForm copyWith({
    String? title,
    String? description,
  }) =>
      CreateTodoForm(
        title: title ?? this.title,
        description: description ?? this.description,
      );
}
