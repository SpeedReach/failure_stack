part of 'result.dart';

///Representing a Ok result.
class Ok<T, F> extends Result<T, F> {
  final T value;

  const Ok(this.value);

  @override
  T expect(String msg) {
    return value;
  }

  @override
  F? get fail => null;

  @override
  bool get isFail => false;

  @override
  bool get isOk => true;

  @override
  Result<U, F> map<U>(U Function(T p1) func) {
    return Ok(func(value));
  }

  @override
  Result<T, F2> mapFail<F2>(F2 Function(F failure) func) {
    return Ok(value);
  }

  @override
  ReturnValue match<ReturnValue>(
      {required ReturnValue Function(T p1) ok,
      required ReturnValue Function(F p1) fail}) {
    return ok(value);
  }

  @override
  T? get ok => value;

  @override
  Result<T, F2> pushFail<F2>(F2 newFailure) {
    return Ok(value);
  }

  @override
  T unwrap() {
    return value;
  }

  @override
  T unwrapOr(T defaultValue) {
    return value;
  }

  @override
  T unwrapOrElse(T Function() func) {
    return value;
  }

  @override
  Result<T, F> attach(Object o) {
    return this;
  }
}
