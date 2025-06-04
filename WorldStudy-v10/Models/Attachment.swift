//
//  Attachment.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 6/4/25.
//
import Foundation

struct Attachment: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let fileName: String
    let fileUrl: String
    let fileSize: Int
    let fileType: String
    let createdAt: Date
    let questionId: Int
}
