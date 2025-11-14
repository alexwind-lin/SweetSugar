import Testing
import Foundation
@testable import SweetSugar

@Test func testCodableDict() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let json = """
        {"hello":10,"male":false,"world":"test"}
        """
    let dest: [String: Any] = [
        "hello": 10,
        "world": "test",
        "male": false
    ]
    let dict = try JSONDecoder().decode(CodableDict.self, from: .init(json.utf8))
    #expect((dest as NSDictionary).isEqual(to: dict.dict))
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
    let data = try encoder.encode(dict)
    let plain = String(decoding: data, as: UTF8.self)
    #expect(plain == json)
    
}
