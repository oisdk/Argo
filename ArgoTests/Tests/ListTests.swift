import XCTest
import Argo

private func randArray(length: Int) -> [Int] {
  return (0..<length).map { _ in Int.rand }
}

extension Int {
  private static var rand: Int {
    return Int(arc4random_uniform(UInt32.max))
  }
}

func behavesSame<E:Equatable>(onAr: [Int] -> E, onList: List<Int> -> E) -> Void {
  for randAr in (0..<20).map(randArray) {
    XCTAssertEqual(onAr(randAr), onList(List(randAr)))
  }
}

func behavesSame<E:Equatable>(onAr: [Int] -> E?, onList: List<Int> -> E?) -> Void {
  for randAr in (0..<20).map(randArray) {
    XCTAssertEqual(onAr(randAr), onList(List(randAr)))
  }
}

func behavesSame(onAr: [Int] -> [Int], onList: List<Int> -> List<Int>) -> Void {
  for randAr in (0..<20).map(randArray) {
    XCTAssertEqual(onAr(randAr), Array(onList(List(randAr))))
  }
}


class ListTests: XCTestCase {
  
  func testDebugDescription() {
    
    behavesSame({String($0)}, onList: {String($0)})
    
  }
  
  func testOperator() {
    
    for randAr in (0..<20).map(randArray) {
      let list = randAr.reverse().reduce(List<Int>.None) { $1 >| $0 }
      XCTAssertEqual(Array(list), randAr)
    }
  }


  func testSeqInit() {
    for randAr in (0..<20).map(randArray) {
      XCTAssertEqual(Array(List(randAr)), randAr)
    }
  }

  func testArrayLiteralConvertible() {
    
    let expectation = [1, 2, 3]
    
    let reality: List = [1, 2, 3]
    
    XCTAssertEqual(expectation, Array(reality))
  }


  func testEmptyArrayLiteralConvertible() {
    
    let expectation: List<Int> = .None
    
    let reality: List<Int> = []
    
    XCTAssert(expectation.elementsEqual(reality))
    
  }
  
  func testAppended() {
    for _ in 0..<5 {
      let n = Int.rand
      behavesSame({$0 + [n]}, onList: {$0.appended(n)})
    }
    
  }

  func testProperties() {
    behavesSame({$0.count}, onList: {$0.count})
    behavesSame({$0.isEmpty}, onList: {$0.isEmpty})
    behavesSame({$0.first}, onList: {$0.first})
    behavesSame({$0.last}, onList: {$0.last})
  }

  func testDrop() {
    for n in (0..<5) {
      behavesSame({ Array($0.dropFirst(n)) }, onList: {$0.dropFirst(n)})
      behavesSame({ Array($0.dropLast(n)) }, onList: {$0.dropLast(n)})
    }
  }

  func testExtended() {
    for randAr in (0..<10).map(randArray) {
      behavesSame({$0 + randAr}, onList: {$0.extended(List(randAr))})
    }
  }
  
  func testFfix() {
    for n in (0..<5) {
      behavesSame({ Array($0.prefix(n)) }, onList: {$0.prefix(n)})
      behavesSame({ Array($0.suffix(n)) }, onList: {$0.suffix(n)})
      behavesSame({ Array($0.suffix(n)) }, onList: {$0.suffix(n)})
    }
  }

  func testSplit() {
    let maxSplits = (0...20)
    let splitFuncs = (0...10).map {
      _ -> (Int -> Bool) in
      let n = Int(arc4random_uniform(5)) + 1
      return { $0 % n == 0 }
    }
    let allows = [true, false]
    let arrays = (0...10).map { (a: Int) -> [Int] in
      (0..<a).map { _ in Int(arc4random_uniform(100)) }
    }
    let lists = arrays.map{List($0)}
    for (array, list) in zip(arrays, lists) {
      for maxSplit in maxSplits {
        for splitFunc in splitFuncs {
          for allow in allows {
            let listSplit = list.split(maxSplit, allowEmptySlices: allow, isSeparator: splitFunc)
            let araySplit = array.split(maxSplit, allowEmptySlices: allow, isSeparator: splitFunc)
            for (a, b) in zip(listSplit, araySplit) {
              XCTAssert(a.elementsEqual(b), String(a) + " " + String(b))
            }
          }
        }
      }
    }
  }
}