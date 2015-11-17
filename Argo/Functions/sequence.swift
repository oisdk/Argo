public func sequence<T>(xs: [Decoded<T>]) -> Decoded<[T]> {
  var accum: Decoded<[T]> = pure([])

  for elem in xs {
    switch (accum, elem) {
    case (.Success(var a), .Success(let x)):
      a.append(x)
      accum = pure(a)
    case let (.Failure(e), _): accum = .Failure(e)
    case let (_, .Failure(e)): accum = .Failure(e)
    default: break
    }
  }

  return accum
}

public func sequence<T>(xs: [String: Decoded<T>]) -> Decoded<[String: T]> {
  return xs.reduce(pure([:])) { accum, elem in
    curry(+) <^> accum <*> ({ [elem.0: $0] } <^> elem.1)
  }
}
