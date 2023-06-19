



import 'package:failure_stack/failure_stack.dart';
import 'package:test/scaffolding.dart';

void main(){
  test("test ok", () {
    final ok = Ok(1);
    assert(ok.unwrap() == 1);
    assert(ok.unwrapOr(2) == 1);
    assert(ok.unwrapOrElse(() => 2) == 1);
    assert(ok.map((p1) => 2).ok == 2);
    assert(ok.mapFail((failure) => -1).isOk);
    assert(ok.isOk);
    assert(!ok.isFail);
    assert(ok.ok  == 1);
    assert(ok.fail == null);
    final newOk = ok.map((p1) => p1+1);
    assert(newOk.ok == 2);
    assert(ok.pushFail(3).isOk);
    ok.attach("printable");

    ok.expect("should not fail");
  });

  group("test fail", () {
    final fail = Fail<int,String>("failed");
    test("basic", () {
      assert(fail.isFail);
      assert(!fail.isOk );
      assert(fail.fail == "failed");
      assert(fail.ok == null);
      assert(fail.failure == "failed");
    });
    test("attachment", () {
      fail.attach("attachment1");
      assert(fail.attachments[0] == "attachment1");
    });
    test("map", () {
      assert(fail.mapFail((failure) => -1).fail == -1);
      assert(fail.map((p1) => 2).isFail);
    });
    test("unwrap", () {
      assert(fail.unwrapOr(2) == 2);
      assert(fail.unwrapOrElse(() => 3) == 3 );
    });
  });



  group("result handle environment", () {

    test("async environment no error", () async {
      final r = await failFutureNumber();
      Result<int,int> result = await asyncResultHandleEnvironment(() async {
        return Ok(r.pushFail(-1).unwrap());
      });
      assert(result.isFail);
      assert(result.fail == -1);
    });

    test("async environment with error", () async{
      final r = await failFutureNumber();
      FailureTypeError? e;
      try{
        await asyncResultHandleEnvironment<int,int>(() async {
          return Ok(r.unwrap());
        });
      }
      on FailureTypeError catch (er){
        e = er;
      }
      assert(e != null);
    });

    test("sync environment no error", (){
      final fail = Fail<int,String>("failed");
      Result<int,int> result = resultHandleEnvironment(() => Ok(fail.pushFail(-1).unwrap()));
      assert(result.isFail);
      assert(result.fail == -1);
    });

    test("sync env with error", (){
      FailureTypeError? e;
      try{
        final fail = Fail<int,String>("failed");
        resultHandleEnvironment<int,int>(() => Ok(fail.unwrap()));
      }
      on FailureTypeError catch(er){
        e = er;
      }
      assert(e != null);
      print(e);
    });

  });


  test("adapt Exceptions and Errors", () {
    Result<int,FormatException> parse(String s) {
      try{
        return Ok(int.parse(s));
      }
      on FormatException catch(e){
        return e.intoFailure();
      }
    }

    final s = parse("1");
    assert(s.isOk);
    assert(s.ok == 1);
    final f = parse("s1");
    assert(f.isFail);
    assert(f.fail != null);
  });

  test("UI", () {
    final f1 = Fail(1);
    final f2 = f1.pushFail(2);
    f2.attach("aatttt 1");
    f2.attach("attt 2");
    print(f2);
    print(f1.stack.latestFailure);
  });

}


Future<Result<int,String>> failFutureNumber() async{
  return Future.delayed(Duration(microseconds: 1), ()=> Fail("failed"));
}

