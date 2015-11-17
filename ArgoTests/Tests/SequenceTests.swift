import XCTest
import Argo

class SequenceTests: XCTestCase {
  func testSequenceSucceeds() {
    let xs: [Decoded<String>] = ["hello", "world", "sequence", "test"].map(pure)
    let ys = sequence(xs)
    XCTAssert(ys.value != nil)
    XCTAssert(ys.value?.count == 4)
  }

  func testSequenceFails() {
    let xs: [Decoded<String>] = ["hello", "world", "sequence", "test"].map(pure) + [.customError("Failure")]
    let ys = sequence(xs)
    XCTAssert(ys.value == nil)
  }
}
