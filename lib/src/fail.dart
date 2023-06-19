part of 'result.dart';

///Representing a failed result.
class Fail<T, F> extends Result<T, F> {
  final F failure;

  final FailureStack<F> stack;

  const Fail._(this.failure, this.stack);

  factory Fail(F failure) {
    String line = _getInvokeLine();
    _Failure<F> f = _Failure(failure, line);
    return Fail._(failure, FailureStack(f));
  }

  @override
  T expect(String msg) {
    assert(false, msg);
    throw stack;
  }

  @override
  F? get fail => failure;

  List<Object> get attachments => stack.latestFailure.attachments;

  @override
  bool get isFail => true;

  @override
  bool get isOk => false;

  @override
  Result<U, F> map<U>(U Function(T p1) func) {
    return Fail(failure);
  }

  @override
  Result<T, F2> mapFail<F2>(F2 Function(F failure) func) {
    String location = _getInvokeLine();
    F2 newFailure = func(failure);
    return Fail<T, F2>._(
        newFailure, stack.pushFailure(_Failure(newFailure, location)));
  }


  @override
  T? get ok => null;

  @override
  Result<T, F2> pushFail<F2>(F2 newFailure) {
    String location = _getInvokeLine();
    return Fail<T, F2>._(
        newFailure, stack.pushFailure(_Failure(newFailure, location)));
  }

  @override
  T unwrap() {
    throw stack;
  }

  @override
  T unwrapOr(T defaultValue) {
    return defaultValue;
  }

  @override
  T unwrapOrElse(T Function() func) {
    return func();
  }

  @override
  Result<T, F> attach(Object o) {
    stack.latestFailure.attachPrintable(o);
    return this;
  }

  @override
  String toString() {
    return stack.toString();
  }
}

extension FailureAdapter<F extends Object> on F {
  Result<T, F> intoFailure<T>() {
    String invokeLine = _getInvokeLine();
    var failure = _Failure(this, invokeLine);
    return Fail._(
        this, FailureStack._new(failure, List.of([failure], growable: false)));
  }
}
