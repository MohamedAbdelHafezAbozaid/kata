public protocol SpeakerInput {
    func inputForSpeaker(completion: @escaping(String?) -> Void)
}

public class Speaker {
    
    private let input: SpeakerInput
    private var text: String?
    
    public init (input: SpeakerInput, text: String?) {
        self.input = input
        self.text = text
    }

    public func saySomething(completion: @escaping (String?) -> Void) {
        input.inputForSpeaker { [weak self] inputText in
            guard let self = self else {return}
            self.text = inputText
            completion(inputText)
        }
        
    }
    
    public func textGetter() -> String? {
        return self.text
    }
}



