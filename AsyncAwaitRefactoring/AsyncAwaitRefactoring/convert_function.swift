enum CustomError : Error {
  case Bad
}

func simple(_ completion: (String) -> Void) { }
func simple2(arg: String, _ completion: (String) -> Void) { }
func simpleErr(arg: String, _ completion: (String?, Error?) -> Void) { }
func simpleRes(arg: String, _ completion: (Result<String, Error>) -> Void) { }
func run(block: () -> Bool) -> Bool { return false }

// RUN: %refactor -convert-to-async -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=NESTED %s
func nested() {
  simple {
    simple2(arg: $0) { str2 in
      print(str2)
    }
  }
}
// NESTED: func nested() async {
// NESTED-NEXT: let val0 = await simple()
// NESTED-NEXT: let str2 = await simple2(arg: val0)
// NESTED-NEXT: print(str2)
// NESTED-NEXT: }

// RUN: %refactor -convert-to-async -dump-text -source-filename %s -pos=%(line+2):9 | %FileCheck -check-prefix=ATTRIBUTES %s
@available(*, deprecated, message: "Deprecated")
private func functionWithAttributes() {
  simple { str in
    print(str)
  }
}
// ATTRIBUTES: convert_function.swift [[# @LINE-6]]:1 -> [[# @LINE-1]]:2
// ATTRIBUTES-NEXT: @available(*, deprecated, message: "Deprecated")
// ATTRIBUTES-NEXT: private func functionWithAttributes() async {
// ATTRIBUTES-NEXT: let str = await simple()
// ATTRIBUTES-NEXT: print(str)
// ATTRIBUTES-NEXT: }

// RUN: %refactor -convert-to-async -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=MANY-NESTED %s
func manyNested() {
  simple { str1 in
    print("simple")
    simple2(arg: str1) { str2 in
      print("simple2")
      simpleErr(arg: str2) { str3, err in
        print("simpleErr")
        guard let str3 = str3, err == nil else {
          return
        }
        simpleRes(arg: str3) { res in
          print("simpleRes")
          if case .success(let str4) = res {
            print("\(str1) \(str2) \(str3) \(str4)")
            print("after")
          }
        }
      }
    }
  }
}
// MANY-NESTED: func manyNested() async {
// MANY-NESTED-NEXT: let str1 = await simple()
// MANY-NESTED-NEXT: print("simple")
// MANY-NESTED-NEXT: let str2 = await simple2(arg: str1)
// MANY-NESTED-NEXT: print("simple2")
// MANY-NESTED-NEXT: let str3 = try await simpleErr(arg: str2)
// MANY-NESTED-NEXT: print("simpleErr")
// MANY-NESTED-NEXT: let str4 = try await simpleRes(arg: str3)
// MANY-NESTED-NEXT: print("simpleRes")
// MANY-NESTED-NEXT: print("\(str1) \(str2) \(str3) \(str4)")
// MANY-NESTED-NEXT: print("after")
// MANY-NESTED-NEXT: }

// RUN: %refactor -convert-to-async -dump-text -source-filename %s -pos=%(line+2):1 | %FileCheck -check-prefix=ASYNC-SIMPLE %s
// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=ASYNC-SIMPLE %s
func asyncParams(arg: String, _ completion: (String?, Error?) -> Void) {
  simpleErr(arg: arg) { str, err in
    print("simpleErr")
    guard let str = str, err == nil else {
      completion(nil, err!)
      return
    }
    completion(str, nil)
    print("after")
  }
}
// ASYNC-SIMPLE: func {{[a-zA-Z_]+}}(arg: String) async throws -> String {
// ASYNC-SIMPLE-NEXT: let str = try await simpleErr(arg: arg)
// ASYNC-SIMPLE-NEXT: print("simpleErr")
// ASYNC-SIMPLE-NEXT: {{^}}return str{{$}}
// ASYNC-SIMPLE-NEXT: print("after")
// ASYNC-SIMPLE-NEXT: }

// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=ASYNC-SIMPLE %s
func asyncResErrPassed(arg: String, _ completion: (Result<String, Error>) -> Void) {
  simpleErr(arg: arg) { str, err in
    print("simpleErr")
    guard let str = str, err == nil else {
      completion(.failure(err!))
      return
    }
    completion(.success(str))
    print("after")
  }
}

// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=ASYNC-ERR %s
func asyncResNewErr(arg: String, _ completion: (Result<String, Error>) -> Void) {
  simpleErr(arg: arg) { str, err in
    print("simpleErr")
    guard let str = str, err == nil else {
      completion(.failure(CustomError.Bad))
      return
    }
    completion(.success(str))
    print("after")
  }
}
// ASYNC-ERR: func asyncResNewErr(arg: String) async throws -> String {
// ASYNC-ERR-NEXT: do {
// ASYNC-ERR-NEXT: let str = try await simpleErr(arg: arg)
// ASYNC-ERR-NEXT: print("simpleErr")
// ASYNC-ERR-NEXT: {{^}}return str{{$}}
// ASYNC-ERR-NEXT: print("after")
// ASYNC-ERR-NEXT: } catch let err {
// ASYNC-ERR-NEXT: throw CustomError.Bad
// ASYNC-ERR-NEXT: }
// ASYNC-ERR-NEXT: }

// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=ASYNC-UNHANDLED %s
func asyncUnhandledCompletion(_ completion: (String) -> Void) {
  simple { str in
    let success = run {
      completion(str)
      return true
    }
    if !success {
      completion("bad")
    }
  }
}
// ASYNC-UNHANDLED: func asyncUnhandledCompletion() async -> String {
// ASYNC-UNHANDLED-NEXT: let str = await simple()
// ASYNC-UNHANDLED-NEXT: let success = run {
// ASYNC-UNHANDLED-NEXT:   <#completion#>(str)
// ASYNC-UNHANDLED-NEXT:   {{^}} return true{{$}}
// ASYNC-UNHANDLED-NEXT: }
// ASYNC-UNHANDLED-NEXT: if !success {
// ASYNC-UNHANDLED-NEXT: {{^}} return "bad"{{$}}
// ASYNC-UNHANDLED-NEXT: }
// ASYNC-UNHANDLED-NEXT: }

// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=ASYNC-UNHANDLED-COMMENT %s
func asyncUnhandledCommentedCompletion(_ completion: (String) -> Void) {
  // a
  simple { str in // b
    // c
    let success = run {
      // d
      completion(str)
      // e
      return true
      // f
    }
    // g
    if !success {
      // h
      completion("bad")
      // i
    }
    // j
  }
  // k
}
// ASYNC-UNHANDLED-COMMENT:      func asyncUnhandledCommentedCompletion() async -> String {
// ASYNC-UNHANDLED-COMMENT-NEXT:   // a
// ASYNC-UNHANDLED-COMMENT-NEXT:   let str = await simple()
// ASYNC-UNHANDLED-COMMENT-NEXT:   // b
// ASYNC-UNHANDLED-COMMENT-NEXT:   // c
// ASYNC-UNHANDLED-COMMENT-NEXT:   let success = run {
// ASYNC-UNHANDLED-COMMENT-NEXT:     // d
// ASYNC-UNHANDLED-COMMENT-NEXT:     <#completion#>(str)
// ASYNC-UNHANDLED-COMMENT-NEXT:     // e
// ASYNC-UNHANDLED-COMMENT-NEXT:     {{^}} return true{{$}}
// ASYNC-UNHANDLED-COMMENT-NEXT:     // f
// ASYNC-UNHANDLED-COMMENT-NEXT:   }
// ASYNC-UNHANDLED-COMMENT-NEXT:   // g
// ASYNC-UNHANDLED-COMMENT-NEXT:   if !success {
// ASYNC-UNHANDLED-COMMENT-NEXT:     // h
// ASYNC-UNHANDLED-COMMENT-NEXT:     {{^}} return "bad"{{$}}
// ASYNC-UNHANDLED-COMMENT-NEXT:     // i
// ASYNC-UNHANDLED-COMMENT-NEXT:   }
// ASYNC-UNHANDLED-COMMENT-NEXT:   // j
// ASYNC-UNHANDLED-COMMENT-NEXT:   {{ }}
// ASYNC-UNHANDLED-COMMENT-NEXT:   // k
// ASYNC-UNHANDLED-COMMENT-NEXT: }

// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix VOID-AND-ERROR-HANDLER %s
func voidAndErrorCompletion(completion: (Void?, Error?) -> Void) {
  if .random() {
    completion((), nil) // Make sure we drop the ()
  } else {
    completion(nil, CustomError.Bad)
  }
}
// VOID-AND-ERROR-HANDLER:      func voidAndErrorCompletion() async throws {
// VOID-AND-ERROR-HANDLER-NEXT:   if .random() {
// VOID-AND-ERROR-HANDLER-NEXT:     return // Make sure we drop the ()
// VOID-AND-ERROR-HANDLER-NEXT:   } else {
// VOID-AND-ERROR-HANDLER-NEXT:     throw CustomError.Bad
// VOID-AND-ERROR-HANDLER-NEXT:   }
// VOID-AND-ERROR-HANDLER-NEXT: }

// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix TOO-MUCH-VOID-AND-ERROR-HANDLER %s
func tooMuchVoidAndErrorCompletion(completion: (Void?, Void?, Error?) -> Void) {
  if .random() {
    completion((), (), nil) // Make sure we drop the ()s
  } else {
    completion(nil, nil, CustomError.Bad)
  }
}
// TOO-MUCH-VOID-AND-ERROR-HANDLER:      func tooMuchVoidAndErrorCompletion() async throws {
// TOO-MUCH-VOID-AND-ERROR-HANDLER-NEXT:   if .random() {
// TOO-MUCH-VOID-AND-ERROR-HANDLER-NEXT:     return // Make sure we drop the ()s
// TOO-MUCH-VOID-AND-ERROR-HANDLER-NEXT:   } else {
// TOO-MUCH-VOID-AND-ERROR-HANDLER-NEXT:     throw CustomError.Bad
// TOO-MUCH-VOID-AND-ERROR-HANDLER-NEXT:   }
// TOO-MUCH-VOID-AND-ERROR-HANDLER-NEXT: }

// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix VOID-RESULT-HANDLER %s
func voidResultCompletion(completion: (Result<Void, Error>) -> Void) {
  if .random() {
    completion(.success(())) // Make sure we drop the .success(())
  } else {
    completion(.failure(CustomError.Bad))
  }
}
// VOID-RESULT-HANDLER:      func voidResultCompletion() async throws {
// VOID-RESULT-HANDLER-NEXT:   if .random() {
// VOID-RESULT-HANDLER-NEXT:     return // Make sure we drop the .success(())
// VOID-RESULT-HANDLER-NEXT:   } else {
// VOID-RESULT-HANDLER-NEXT:     throw CustomError.Bad
// VOID-RESULT-HANDLER-NEXT:   }
// VOID-RESULT-HANDLER-NEXT: }

// RUN: %refactor -convert-to-async -dump-text -source-filename %s -pos=%(line+2):1 | %FileCheck -check-prefix=NON-COMPLETION-HANDLER %s
// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=NON-COMPLETION-HANDLER %s
func functionWithSomeHandler(handler: (String) -> Void) {}
// NON-COMPLETION-HANDLER: func functionWithSomeHandler() async -> String {}

// rdar://77789360 Make sure we don't print a double return statement.
// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=RETURN-HANDLING %s
func testReturnHandling(_ completion: (String?, Error?) -> Void) {
  return completion("", nil)
}
// RETURN-HANDLING:      func testReturnHandling() async throws -> String {
// RETURN-HANDLING-NEXT:   {{^}} return ""{{$}}
// RETURN-HANDLING-NEXT: }

// rdar://77789360 Make sure we don't print a double return statement and don't
// completely drop completion(a).
// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=RETURN-HANDLING2 %s
func testReturnHandling2(completion: @escaping (String) -> ()) {
  testReturnHandling { x, err in
    guard let x = x else {
      let a = ""
      return completion(a)
    }
    let b = ""
    return completion(b)
  }
}
// RETURN-HANDLING2:      func testReturnHandling2() async -> String {
// RETURN-HANDLING2-NEXT:   do {
// RETURN-HANDLING2-NEXT:     let x = try await testReturnHandling()
// RETURN-HANDLING2-NEXT:     let b = ""
// RETURN-HANDLING2-NEXT:     {{^}}<#return#> b{{$}}
// RETURN-HANDLING2-NEXT:   } catch let err {
// RETURN-HANDLING2-NEXT:     let a = ""
// RETURN-HANDLING2-NEXT:     {{^}}<#return#> a{{$}}
// RETURN-HANDLING2-NEXT:   }
// RETURN-HANDLING2-NEXT: }

// FIXME: We should arguably be able to handle transforming this completion handler call (rdar://78011350).
// RUN: %refactor -add-async-alternative -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=RETURN-HANDLING3 %s
func testReturnHandling3(_ completion: (String?, Error?) -> Void) {
  return (completion("", nil))
}
// RETURN-HANDLING3:      func testReturnHandling3() async throws -> String {
// RETURN-HANDLING3-NEXT:   {{^}} return (<#completion#>("", nil)){{$}}
// RETURN-HANDLING3-NEXT: }

// RUN: %refactor -convert-to-async -dump-text -source-filename %s -pos=%(line+1):1 | %FileCheck -check-prefix=RDAR78693050 %s
func rdar78693050(_ completion: () -> Void) {
  simple { str in
    print(str)
  }
  if .random() {
    return completion()
  }
  completion()
}

// RDAR78693050:      func rdar78693050() async {
// RDAR78693050-NEXT:   let str = await simple()
// RDAR78693050-NEXT:   print(str)
// RDAR78693050-NEXT:   if .random() {
// RDAR78693050-NEXT:     return
// RDAR78693050-NEXT:   }
// RDAR78693050-NEXT:   return
// RDAR78693050-NEXT: }
