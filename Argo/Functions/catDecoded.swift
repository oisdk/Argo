public func catDecoded<T>(xs: List<Decoded<T>>) -> List<T> {
  return xs.reduceR(List<T>.None) { (elem, accum) in
    elem.map(>|accum) ?? accum
  }
}

public func catDecoded<T>(xs: [String: Decoded<T>]) -> [String: T] {
  var accum: [String:T] = [:]
  for (k,x) in xs { if case let .Success(v) = x { accum[k] = v } }
  return accum
}
