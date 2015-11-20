public func catDecoded<T>(xs: List<Decoded<T>>) -> List<T> {
  return xs.reduceR(List<T>.Nil) { (elem, accum) in
    elem.map(>|accum) ?? accum
  }
}

public func catDecoded<T>(xs: [String: Decoded<T>]) -> [String: T] {
  var res: [String:T] = [:]
  for (k,v) in xs {
    if let v = v.value {
      res[k] = v
    }
  }
  return res
}
