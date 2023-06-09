import XCTest
import Kata



final class SpeakerTests: XCTestCase {
    
    func testSaySaySomething() throws {
        let (sut, spy) = makeSUT(text: "Hello?")
        expect(sut, toCompleteWith: "Hello?") {
            spy.toComplete(with: "Hello?")
        }
    }

    func testTextValueInSaySomething() throws {
        let (sut, spy) = makeSUT()
        expect(sut, toCompleteWith: sut.textGetter()){
            spy.toComplete(with: SpeakerTests.defaultValue)
        }
    }
    
    func testDefaultText() throws {
        let (sut, _) = makeSUT()
        XCTAssertEqual(sut.textGetter(), "Default text")
    }
    
        //MARK: -  Helpers:-
    
    private func expect(_ sut: Speaker, toCompleteWith expectedResult: String?, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        var receivedValue: String?
        let exp = expectation(description: "wait for completion")
        sut.saySomething { value in
            receivedValue = value
            exp.fulfill()
        }
         action()
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(expectedResult, receivedValue, file: file, line: line)
    }
    
    private static let defaultValue = "Default text"
    
    private func makeSUT(text: String? = defaultValue) -> (sut: Speaker, spy: speakerOnputspy) {
        let spy = speakerOnputspy()
        let sut = Speaker(input: spy, text: text)
        return (sut, spy)
    }
    
    private class speakerOnputspy: SpeakerInput {
        var completions = [(String?) -> Void]()
        
        func inputForSpeaker(completion: @escaping(String?) -> Void) {
            completions.append(completion)
        }
        
        func toComplete(with text: String, at index: Int = 0) {
            completions[index](text)
        }
    }
}
