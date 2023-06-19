



import 'package:failure_stack/failure_stack.dart';
import 'package:test/scaffolding.dart';

void main(){
  test("test ok", () {
    final ok = Ok(1);
    assert(ok.unwrap() == 1);
    assert(ok.isOk);
    assert(!ok.isFail);
    assert(ok.ok  == 1);
    assert(ok.fail == null);
    final newOk = ok.map((p1) => p1+1);
    assert(newOk.ok == 2);
  });

  test("test fail", () {
    final fail = Fail<int,String>("failed");
    assert(fail.isFail);
    assert(!fail.isOk );
    assert(fail.fail == "failed");
    assert(fail.failure == "failed");
    fail.attach("attachment1");
    assert(fail.attachments[0] == "attachment1");
    final newFail = fail.mapFail((failure) => -1);
    assert(newFail.fail == -1);
  });

  test("sync environment", (){
    final fail = Fail<int,String>("failed");
    Result<int,int> result = resultHandleEnvironment(() => Ok(fail.pushFail(-1).unwrap()));
    assert(result.isFail);
    assert(result.fail == -1);
  });

  test("async environment", () async {
    Result<int,int> result = await asyncResultHandleEnvironment(() async {
      final result = (await failFutureNumber()).pushFail(-1);
      return Ok(result.unwrap());
    });
    assert(result.isFail);
    assert(result.fail == -1);
  });

  test("adapt Exceptions and Errors", () {
    final s = parse("1");
    assert(s.isOk);
    assert(s.ok == 1);
    final f = parse("s1");
    assert(f.isFail);
    assert(f.fail != null);
  });


}


Future<Result<int,String>> failFutureNumber() async{
  return Future.delayed(Duration(microseconds: 1), ()=> Fail("failed"));
}

Result<int,FormatException> parse(String s) {
  try{
    return Ok(int.parse(s));
  }
  on FormatException catch(e){
    return e.intoFailure();
  }
}