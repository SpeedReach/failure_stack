import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_stack/failure_stack.dart';
import 'package:todo_ddd_demo/application/create_todo_cubit.dart';
import 'package:todo_ddd_demo/application/create_todo_failure.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = CreateTodoCubit(context.read());
    return BlocProvider<CreateTodoCubit>.value(
      value: cubit,
      child: Scaffold(
        body: Column(
          children: [
            TextField(onChanged: (text) => cubit.setTitle(text)),
            TextField(onChanged: (text) => cubit.setDescription(text)),
            TextButton(
              onPressed: () async {
                final result = await cubit.createTodo();
                switch (result) {
                  case Ok<String, CreateTodoFailure> ok:
                    {
                      debugPrint("Success: ${ok.value}");
                      //showDialog(context: context, builder: (_) => Text("Success: ${ok.value}"));
                    }
                  case Fail<String, CreateTodoFailure> fail:
                    {
                      debugPrint("Fail: ${fail.failure}");
                      //showDialog(context: context, builder: (_) => Text("Fail: ${fail.failure}"));
                    }
                }
              },
              child: const Text("Create Task"),
            )
          ],
        ),
      ),
    );
  }
}
