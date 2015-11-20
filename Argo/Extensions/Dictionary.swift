// pure merge for Dictionaries
func + <T, U>(var lhs: [T: U], rhs: [T: U]) -> [T: U] {
  for (key, val) in rhs {
    lhs[key] = val
  }
  return lhs
}

extension Dictionary {
  func map<T>(@noescape f: Value -> T) -> [Key: T] {
    var accum: [Key:T] = [:]
    for (k,v) in self { accum[k] = f(v) }
    return accum
  }
}

func <^> <T, U, V>(@noescape f: T -> U, x: [V: T]) -> [V: U] {
  return x.map(f)
}
