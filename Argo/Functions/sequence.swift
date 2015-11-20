public func sequence<T>(xs: List<Decoded<T>>) -> Decoded<List<T>> {
  return xs.reduceR(pure([])) { elem, accum in (>|) <^> elem <*> accum }
}

public func sequence<T>(xs: [String: Decoded<T>]) -> Decoded<[String: T]> {
  return xs.reduce(pure([:])) { accum, elem in
    curry(+) <^> accum <*> ({ [elem.0: $0] } <^> elem.1)
  }
}
