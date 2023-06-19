import 'package:failure_stack/failure_stack.dart';

Result<int, FormatException> parseString(String s) {
  try {
    return Ok(int.parse(s));
  } on FormatException catch (e) {
    Result<int, FormatException> r = e.intoFailure();
    return r.attach("Failed parsing $s to int");
  }
}

class ParseExperimentFailure {
  const ParseExperimentFailure();
  @override
  String toString() {
    return "ParseExperimentFailure: invalid experiment input";
  }
}

Result<List<int>, ParseExperimentFailure> parseExperiment(String input) {
  return resultHandleEnvironment(() {
    final values = input
        .split(" ")
        .map((e) => parseString(e))
        .map((e) => e.pushFail(const ParseExperimentFailure()))
        .map((e) => e.unwrap())
        .toList(growable: false);
    return Ok(values);
  });
}

class ExperimentError {
  @override
  String toString() {
    return "ExperimentError: could not run experiment";
  }
}

Result<List<int>, ExperimentError> startExperiments(Map<int, String> inputs) {
  return resultHandleEnvironment(() {
    List<int> finalResults = [];

    inputs.entries.map((e) {
      return parseExperiment(e.value).pushFail(ExperimentError()).unwrap();
    }).forEach((element) => finalResults.addAll(element));

    return Ok(finalResults);
  });
}

void main() {
  final experimentsInput = {0: "1 5 6", 4: "4 5 6", 6: "3 5w"};

  switch (startExperiments(experimentsInput)) {
    case Ok ok:
      {
        print(ok.value);
      }
    case Fail fail:
      {
        print(fail.stack);
      }
  }
}
