import 'package:failure_stack/failure_stack.dart';
import 'package:test/test.dart';


class ConnectionFailure{
  @override
  String toString() {
    return "ConnectionFailure: Connection time out.";
  }
}
class GetTasksFailure{
  @override
  String toString() {
    return "GetTasksFailure: Could not get tasks.";
  }
}
class ExampleFailure{
  @override
  String toString() {
    return "ExampleFailure: Some error occurred while demo the example.";
  }
}

Result<(),ConnectionFailure> f1() => Fail<(),ConnectionFailure>(ConnectionFailure()).attach("Configured timeout 1000ms");

Result<(), GetTasksFailure> f2() => resultHandleEnvironment(() {

  var f1Result =  f1().pushFail(GetTasksFailure())
      .unwrap();

  return Ok(f1Result);

});

Result<(),ExampleFailure> f3() => resultHandleEnvironment((){
  f2().mapFail((_)=>ExampleFailure()).unwrap();
  return Ok(());
});


void main() {
  group('A group of tests', () {
    final result = f3();
    print((result as Fail).stack);
  });
}
