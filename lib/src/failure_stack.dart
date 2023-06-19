part of 'result.dart';

class FailureStack<F> {
  final _Failure<F> latestFailure;
  final List<_Failure> frames;

  FailureStack(this.latestFailure)
      : frames = List.of([latestFailure], growable: false);

  FailureStack._push(FailureStack originStack, _Failure<F> newFailure)
      : latestFailure = newFailure,
        frames = List.from([
          newFailure,
          for (var f in originStack.frames) f,
        ], growable: false);

  FailureStack._new(this.latestFailure, this.frames);

  FailureStack<F2> pushFailure<F2>(_Failure<F2> newFailure) {
    return FailureStack._push(this, newFailure);
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer("Failure: ");
    int backtrace = 0;

    void writeMultiple(int amount, String string) {
      for (int i = 0; i < amount; i++) {
        buffer.write(string);
      }
    }

    for (final f in frames) {
      if (backtrace != 0) {
        writeMultiple(backtrace - 1, "  ");
        buffer.write("╰");
        writeMultiple(backtrace, "─");
        buffer.write("▶ ");
      }
      buffer.write("${f.failure.toString().replaceAll("\n", "")}\n");
      writeMultiple(backtrace, "  ");
      buffer.write("├╴ at ${f.location}\n");
      for (var att in f._attachments) {
        writeMultiple(backtrace, "  ");
        buffer.write("├╴ $att\n");
      }
      backtrace++;
    }
    writeMultiple(backtrace - 1, "  ");
    buffer.write("╰╴ end");
    return buffer.toString();
  }

}

class _Failure<F> {
  final String location;
  final F failure;
  final List<Object> _attachments = [];

  List<Object> get attachments => List.from(_attachments, growable: false);

  _Failure(this.failure, this.location);

  void attachPrintable(Object o) {
    _attachments.add(o);
  }

  @override
  String toString() {
    return "An failure that occurred on $location";
  }
}
