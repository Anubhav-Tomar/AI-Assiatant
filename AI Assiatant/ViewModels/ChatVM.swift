//
//  ChatVM.swift
//  AI Assiatant
//
//  Created by Anubhav Tomar on 07/12/24.
//

import SwiftUI

extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = []
        @Published var currentInput: String = ""
        
        private let openAIService = OpenAIService()
        
        func sendMessage() {
            let newMessage =  Message(id: UUID(), role: .user, content: currentInput, createdAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            Task {
                let response = await openAIService.sendMessage(message: messages)
                guard let receivedOpenAIMessage = response?.choices.first?.message else {
                    print("Error: No message received")
                    return
                }
                let receivedMessage = Message(id: UUID(),
                                              role: receivedOpenAIMessage.role,
                                              content: receivedOpenAIMessage.content,
                                              createdAt: Date())
                await MainActor.run {
                    messages.append(receivedMessage)
                }
            }
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createdAt: Date
}
