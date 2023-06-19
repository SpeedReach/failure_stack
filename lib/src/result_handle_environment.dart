part of 'result.dart';

///In the [process], results with type [Result<_, NewFailureType>] can be unwrapped safely and elegantly
///without causing errors, because the [resultHandleEnvironment] catches the [FailureStack<NewFailureType>] for us.
///For async processes use [asyncResultHandleEnvironment]. <br><br>
///**Warning: Do not unwrap results that do not match the failure type, use [Result.mapFail] or [Result.pushFail] to change failure type.**
///
///```dart
///Result<int,ParsingExperimentError> experiment(){
///   return resultHandleEnvironment(() {
///     Result<int,ParsingError> result = parse("o13");
///     // We can unwrap here safely.
///     int ok = result.pushFail(ParsingExperimentError()).unwrap();
///     return Ok(ok);
///   });
///}
///```
Result<NewReturnType, NewFailureType>
    resultHandleEnvironment<NewReturnType, NewFailureType>(
        Result<NewReturnType, NewFailureType> Function() process) {
  try {
    return process();
  } on FailureStack<NewFailureType> catch (f) {
    //print(f);
    return Fail._(f.latestFailure.failure, f);
  } on FailureStack catch (f) {
    throw FailureTypeError(NewFailureType, f.latestFailure.failure.runtimeType);
  }
}

///Acts same as the [resultHandleEnvironment] , but for async processes.
Future<Result<NewReturnType, NewFailureType>> asyncResultHandleEnvironment<
        NewReturnType, NewFailureType>(
    Future<Result<NewReturnType, NewFailureType>> Function() process) async {
  try {
    return await process();
  } on FailureStack<NewFailureType> catch (f) {
    //print(f);
    return Fail._(f.latestFailure.failure, f);
  } on FailureStack catch (f) {
    throw FailureTypeError(NewFailureType, f.latestFailure.failure.runtimeType);
  }
}

class FailureTypeError extends Error {
  final Type targetType;
  final Type currentType;

  FailureTypeError(this.targetType, this.currentType);

  @override
  String toString() {
    return """
    Failure type $currentType does not match $targetType, try use Result.push or Result.map to change the failure type.
    """;
  }
}
