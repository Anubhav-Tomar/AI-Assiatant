//
//  OpenAIService.swift
//  AI Assiatant
//
//  Created by Anubhav Tomar on 08/12/24.
//

import SwiftUI
import Alamofire

class OpenAIService {
    
    private let endPointURL = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(message: [Message]) async -> OpenAIChatResponse? {
        
        let openAIMessages = message.map({ OpenAIChatMessage(role: $0.role, content: $0.content) })
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", message: openAIMessages)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIApiKey)"
        ]
        print(openAIMessages)
        return try? await AF.request(endPointURL, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
}


struct OpenAIChatBody: Encodable {
    let model: String
    let message: [OpenAIChatMessage]
}


struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}


enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}


struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}


struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}
