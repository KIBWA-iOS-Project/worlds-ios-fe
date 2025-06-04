//
//  APIService.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/26/25.
//

import Foundation
import Alamofire
import UIKit

class APIService {
    static let shared = APIService()
    let baseURL = "http://72.155.72.12"
    enum APIError: Error {
        case missingToken
    }
    //JWT 토큰 가져오기
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "jwt_token")
    }
    //토큰이 필요한 API 호출을 위한 HTTP헤더 생성
    private func getAuthHeaders() throws -> HTTPHeaders {
        guard let token = getToken() else {
            throw APIError.missingToken
        }
        return ["Authorization": "Bearer \(token)"] //이걸 헤더에 실어보내는 것
    }
    
    // 회원가입
    func signup(email: String, password: String, name: String, role: String) async throws -> Bool {
        let params = ["email": email, "password": password, "name": name, "role": role]

        let response = try await AF.request("\(baseURL)/auth/signup", method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .serializingData()
            .response

        if let error = response.error {
            print("Signup error: \(error.localizedDescription)")
            return false
        }
        return true
    }

    // 로그인
    func login(email: String, password: String) async throws -> (token: String, role: String, name: String, userId: Int)? {
        let params = ["email": email, "password": password]

        let response = try await AF.request("\(baseURL)/auth/login", method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .serializingDecodable(LoginResponse.self)
            .value

        return (response.access_token, response.role, response.name, response.userId)
    }
    
    // 멘토 랭킹
    func fetchMentorRankings() async throws -> [MentorRanking] {
        let headers = try getAuthHeaders()
        let response = try await AF.request("\(baseURL)/answer/ranking/mentors", headers: headers)
            .validate()
            .serializingDecodable([MentorRanking].self)
            .value
        return response
    }
    
    // 멘티 메인화면 사용자 질문 목록
    func fetchUserQuestions(userId: Int) async throws -> [Questions] {
        let headers = try getAuthHeaders()

        let response = try await AF.request("\(baseURL)/question/question", headers: headers)
            .validate()
            .serializingDecodable([Questions].self)
            .value

        return response
            .filter { $0.user.id == userId }
            .sorted { $0.createdAt > $1.createdAt } // 최신순
    }
    
    //게시판 글 목록
    func fetchQuestions() async throws -> [Question] { //[테이블]
        let headers = try getAuthHeaders()
        
        //Alamofire로 /question API에 GET 요청을 보내고, 응답을 [Question]으로 디코딩
        let response = try await AF.request("\(baseURL)/question", headers: headers) //headers는 인증역할
            .serializingDecodable([Question].self)
            .value
        
        return response
    }
    
    //게시글 상세
    func fethQuestionDetail(questionId: Int) async throws -> Question? {
        let headers = try getAuthHeaders()
        
        let response = try await AF.request("\(baseURL)/question/\(questionId)", headers: headers)
            .serializingDecodable(Question.self)
            .value
        return response
    }
    
   //글 작성
    
//    func createQuestion(title: String, content: String, token: String) async throws -> Bool {
//        let params = ["title": title, "content": content, "createdAt": Date().description]
//        let headers = try getAuthHeaders()
//        
//        let response = await AF.request("\(baseURL)/question", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
//            .validate()
//            .serializingData() //->왜 serializingDecodable안썻는지: 서버 응답안받아도돼서. 그냥 성공하면 업로드 되고 끝나면 되니까
//        // 응답 데이터를 Data 형식으로 받음 (JSON을 직접 디코딩 안 함)
//            .response // Alamofire.AFDataResponse<Data> 타입의 전체 응답을 받음
//        
//                return response.error == nil
//    }
    func createQuestion(title: String, content: String, image: UIImage?) async throws -> Bool {
        let headers = try getAuthHeaders()
        let url = "\(baseURL)/question"

        if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
            //이미지까지 전송
            return try await withCheckedThrowingContinuation { continuation in
                AF.upload(multipartFormData: { formData in
                    formData.append(Data(title.utf8), withName: "title")
                    formData.append(Data(content.utf8), withName: "content")
                    formData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                }, to: url, method: .post, headers: headers)
                .validate()
                .response { response in
                    if let error = response.error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: true)
                    }
                }
            }
        } else {
            // 질문 글만 전송
            let params = [
                "title": title,
                "content": content,
                "createdAt": Date().description
            ]
            
            let response = await AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .serializingData()
                .response
            
            return response.error == nil
        }
    }
    

    //댓글 작성
    func createAnswer(questionId: Int, content: String) async throws -> Answer {
        let params = ["content": content]
        let headers = try getAuthHeaders()
        
        let answer = try await AF.request("\(baseURL)/question/\(questionId)/answer", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .serializingDecodable(Answer.self)
            .value
        return answer
    }
    
    //댓글 목록 조회
    func fetchAnswers(questionId: Int) async throws -> [Answer] {
        let headers = try getAuthHeaders()
        
        let response = try await AF.request("\(baseURL)/question/\(questionId)/answer", headers: headers)
            .serializingDecodable([Answer].self)
            .value
        
        return response
    }
    
    struct LoginResponse: Codable {
        let access_token: String
        let role: String
        let name: String
        let userId: Int
    }
}
