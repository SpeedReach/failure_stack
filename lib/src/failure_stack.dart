part of 'result.dart';

///The failure stack that can be printed out.
class FailureStack<F> {
  final Failure<F> latestFailure;
  final List<Failure> frames;

  FailureStack(this.latestFailure)
      : frames = List.of([latestFailure], growable: false);

  FailureStack._push(FailureStack originStack, Failure<F> newFailure)
      : latestFailure = newFailure,
        frames = List.from([
          newFailure,
          for (var f in originStack.frames) f,
        ], growable: false);

  FailureStack._new(this.latestFailure, this.frames);

  FailureStack<F2> _pushFailure<F2>(Failure<F2> newFailure) {
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

///Containing the location of where the failure occurred and the attachments
class Failure<F> {
  final String location;
  final F failure;
  final List<Object> _attachments = [];

  List<Object> get attachments => List.from(_attachments, growable: false);

  Failure(this.failure, this.location);

  void attachPrintable(Object o) {
    _attachments.add(o);
  }

  @override
  String toString() {
    return "An failure that occurred on $location";
  }
}
