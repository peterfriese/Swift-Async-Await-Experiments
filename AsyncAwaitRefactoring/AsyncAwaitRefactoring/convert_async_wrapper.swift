// RUN: %empty-directory(%t)

enum CustomError : Error {
  case e
}

func foo1(_ completion: @escaping () -> Void) {}
func foo2(arg: String, _ completion: @escaping (String) -> Void) {}
func foo3(arg: String, _ arg2: Int, _ completion: @escaping (String?) -> Void) {}
func foo4(_ completion: @escaping (Error?) -> Void) {}
func foo5(_ completion: @escaping (Error) -> Void) {}
func foo6(_ completion: @escaping (String?, Error?) -> Void) {}
func foo7(_ completion: @escaping (String?, Int, Error?) -> Void) {}
func foo8(_ completion: @escaping (String?, Int?, Error?) -> Void) {}
func foo9(_ completion: @escaping (Result<String, Error>) -> Void) {}
func foo10(arg: Int, _ completion: @escaping (Result<(String, Int), Error>) -> Void) {}
func foo11(completion: @escaping (Result<String, Never>) -> Void) {}
func foo12(completion: @escaping (Result<String, CustomError>) -> Void) {}
