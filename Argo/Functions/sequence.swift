public func sequence<T>(xs: [Decoded<T>]) -> Decoded<[T]> {
  var accum: [T] = []

  for elem in xs {
    switch elem {
    case let .Success(value):
        accum.append(value)
    case let .Failure(error):
        return .Failure(error)
    }
   }

  return pure(accum)
}

public func sequence<T>(xs: [String: Decoded<T>]) -> Decoded<[String: T]> {
  return xs.reduce(pure([:])) { accum, elem in
    curry(+) <^> accum <*> ({ [elem.0: $0] } <^> elem.1)
  }
}
