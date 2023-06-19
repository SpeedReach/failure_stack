A error handling library inspired by rust and error-stack.

## Why use failure_stack ?
The origin error handle method: throw catch, may cause unpredicted errors and behaviors,
 by using the result type as the return value. You are forced to handle every failure that might 
occur. 


<p>
  <img src="https://github.com/SpeedReach/failure_stack/blob/main/doc/example-1.jpeg?raw=true"
    alt="An image of the failure stack" height="400"/>
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
     int ok = result.pushFailure(ParsingExperimentError()).unwrap();
     return Ok(ok);
   });
}
```

