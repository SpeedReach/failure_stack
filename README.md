</p>

<p align="center">
<a href=""><img src="https://github.com/SpeedReach/failure_stack/actions/workflows/build.yml/badge.svg" alt="build"></a>
<a href=""><img src="https://codecov.io/gh/SpeedReach/failure_stack/blob/main/graph/badge.svg" alt="codecov"></a>
</p>

---

A error handling library inspired by rust and error-stack, to prevent unpredicted errors.

## Why use failure_stack ?
The origin error handle method: throw catch, may cause unpredicted errors and behaviors,
 by using the result type as the return value. You are forced to handle every failure that might 
occur, making your program less likely to cause errors.  
You may say, I get it , Result and Either types are great, but dartz and fpdart already that
has these, why create another library?  The above mentioned are great libraries for dart functional programming,
but when it comes to error handling , they might not be ideal when your program becomes larger and contains a lot nested function calls.
So above the normal Either type, this package has some additional features.

1. encourage the user to provide a new error type if the scope is changed, usually by crossing layers in apps or 3rd party libraries(for example, `ApiError` for infrastructure layer errors and `InvalidInputError` for application layers.)
2. be able to attach any extra data to failures
3. be able to push failures to the stack and handle them later while still keeping track of them.

<p>
  <img src="https://github.com/SpeedReach/failure_stack/blob/main/doc/example-1.jpeg?raw=true"
    alt="An image of the failure stack" height="300"/>
</p>

## Usage

Let's say we have a function that parses a `String` to `int`, and it may fail when the input is not a number.
```dart
class ParsingFailure{} // The failure representing that the parsing failed

Result<int,ParsingFailure> parse(String numString);

```
When we use the function, we have 3 ways to handle the result.

1. When you don't care about the failure that might occur.
```dart
// .ok returns the contained ok value, since the result might fail, it is a nullable type.
int? result = parse(targetString).ok;
```
2. Exhaustive matching.
```dart
switch(parse(targetString)){
  case Ok<int,ParsingFailure> ok: {
    print("success: ${ok.value}");
  },  
  case Fail<int,ParsingFailure> fail: {
    print("Failed: ${fail.failure}");
  } 
}
```
3. When you are in a function that returns a Result type too,
use `resultHandleEnvironment` instead.
```dart
Result<int,ParsingExperimentError> experiment(){
   return resultHandleEnvironment(() {
     Result<int,ParsingError> result = parse("o13");
     // We can unwrap here safely, in other cases, unwrapping a Fail will throw error.
     // note that we use pushFailure to match Failure type
     int ok = result
             .pushFailure(ParsingExperimentError())
             .attach("extra info") //attach anything you want
             .unwrap();
     return Ok(ok);
   });
}
```

### Converting Exceptions and Errors to Failure

1. use the `intoFailure` function
```dart
Future<Result<(), DioException>> callApi() async {
 try{
  await dio.post(/*some code*/);
 }
 on DioException catch(e){
  return e.intoFailure();
 }
}
```
2. write an adapter function
```dart
  RepositoryFailure intoRepositoryFailure(){
    switch(type){
      case DioExceptionType.connectionTimeout:
        return const ConnectionFailure();
      case DioExceptionType.badResponse:
        if(response == null || response!.statusCode == null) {
          return const UnExpectedFailure(null);
        } else if(response!.statusCode == 401) {
          return const UnAuthorizeFailure();
        } else if(response!.statusCode! >= 500) {
          return const ServerFailure();
        } else if(response!.statusCode! >= 400) {
          return IllegalActionFailure(response!.statusMessage ?? "");
        }
     case DioExceptionType.unknown:
        return const UnExpectedFailure(null);
    }
  }
```