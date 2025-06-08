//
//  Answer.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/23/25.
//

// (멘토)질문게시판 속 답변 데이터 모델링
import Foundation

struct Answer: Codable, Identifiable, Hashable {
    let id: Int
    let content: String
    let userId: Int
    let questionId: Int
    let createdAt: String //ㅋㅋㅋㅋㅋㅋzzz이넘이..문제엿어 ㅡㅡ;;!!
//    let deletedAt: Date?
    let user: User?
}

struct MentorRanking: Identifiable, Codable {
    var id: Int { UUID().hashValue } // 고유 ID (임시)
    let name: String
    let count: Int
}
