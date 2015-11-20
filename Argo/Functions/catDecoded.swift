public func catDecoded<T>(xs: List<Decoded<T>>) -> List<T> {
  return xs.reduceR(List<T>.None) { (elem, accum) in
    elem.map(>|accum) ?? accum
  }
}

public func catDecoded<T>(xs: [String: Decoded<T>]) -> [String: T] {
  return xs.reduce([:]) { accum, elem in
    elem.1.map { accum + [elem.0: $0] } ?? accum
  }
}
