part 'utils.dart';
part 'failure_stack.dart';
part 'ok.dart';
part 'fail.dart';
part 'result_handle_environment.dart';

///A container of the result of a function, determine whether is successes or fails, and let users to handle them differently.
sealed class Result<T,F>{

  const Result();

  ///Returns the contained ok value if success
  ///or else throws the [FailureStack] if the [Result] is not ok
  ///notes: check out [resultHandleEnvironment] to effectively handle results.
  T unwrap();

  ///Returns the contained ok value if success
  ///or else returns the [defaultValue]
  T unwrapOr(T defaultValue);

  ///Returns the contained ok value if success
  ///or else prints the [msg], only for debug purposes.
  T expect(String msg);
  ///Returns the contained ok value if success
  ///or else return the results of evaluating the provided function [func]
  T unwrapOrElse(T Function() func);

  ///Safely returns the ok value or null
  T? get ok;
  //Safely returns the failure or null
  F? get fail;

  /// Check whether the result is Ok or not
  bool get isOk;
  ///Check whether the result is Failure or not
  bool get isFail;

  ///Transforms [Result<T,F>] to [Result<U,F>] by applying the provided function [func] to the contained ok value,
  ///does nothing if it's a fail result.
  Result<U,F> map <U>(U Function(T) func);

  ///Transforms [Result<T,F>] to [Result<T,F2>] by pushing [failure] to the contained [FailureStack] if its a fail result ,
  ///does nothing if it's a ok result.
  Result<T,F2> pushFail <F2> ( F2 newFailure);

  ///Transforms [Result<T,F>] to [Result<T,F2>] by pushing a new failure created by mapping the contained current failure if its a fail result ,
  ///does nothing if it's a ok result.
  Result<T,F2> mapFail<F2> (F2 Function(F failure) func);

  ///Exhaustive matching to do different things for ok or fail value
  ReturnValue match<ReturnValue>({
    required ReturnValue Function(T) ok,
    required ReturnValue Function(F) fail
  });

  /// attach some extra information to be printed when failed
  Result<T,F> attach(Object o);

}
