part of 'result.dart';

final RegExp _regex = RegExp(r"^#\d+\s+.*\s+\((.*)\)$");

String _getInvokeLine() {
  String line = StackTrace.current.toString().split("\n")[2];

  final match = _regex.firstMatch(line);

  return match?.group(1) ?? "";
}
