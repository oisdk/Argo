public func sequence<T>(xs: List<Decoded<T>>) -> Decoded<List<T>> {
  return xs.reduceR(pure([])) { elem, accum in (>|) <^> elem <*> accum }
}

public func sequence<T>(xs: [String: Decoded<T>]) -> Decoded<[String: T]> {
  var accum: [String:T] = [:]
  for (k,x) in xs {
    switch x {
    case let .Success(v): accum[k] = v
    case let .Failure(e): return .Failure(e)
    }
  }
  return .Success(accum)
}
