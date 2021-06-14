func simple(completion: @escaping (String) -> Void) { }
func otherArgs(first: Int, second: String, completion: @escaping (String) -> Void) { }
func emptyNames(first: Int, _ second: String, completion: @escaping (String) -> Void) { }
@completionHandlerAsync("otherName()", completionHandlerIndex: 0)
func otherName(notHandlerName: @escaping (String) -> (Void)) {}
func otherName() async -> String {}

func otherStillConverted() {
  otherName { str in
    print(str)
  }
}
