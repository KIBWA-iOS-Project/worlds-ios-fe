//
//  Question.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/23/25.
//

// (멘티)질문게시판 데이터 모델링
import Foundation

struct Question: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let content: String
    let createdAt: Date
    let deletedAt: Date?
    let userId: Int
    let role: String
    
    let answers: [Answer]?
}

struct Questions: Identifiable, Codable {
    let id: Int
    let title: String
    let content: String
    let userId: Int
    let user: QuestionUser
    let createdAt: String
}

struct QuestionUser: Codable {
    let id: Int
    let email: String
    let name: String
    let role: String
}
