//
//  TranslateAIView.swift
//  WorldStudy-v10
//
//  Created by 이다은 on 6/5/25.
//

import SwiftUI
import Translation

struct RecognizedText: Identifiable {
    let id = UUID()
    let string: String // 인식된 텍스트
    let boundingBox: CGRect // 인식된 텍스트의 박스 좌표
}

// 번역된 텍스트를 저장하는 모델
struct TranslatedText: Identifiable {
    let id = UUID()
    let originalText: String // 원본 텍스트
    let translatedText: String // 번역된 텍스트
    let boundingBox: CGRect // 번역된 텍스트의 박스 좌표
}

struct TranslateAIView: View {
    // OCR 인식된 텍스트를 저장하는 배열
    @State private var recognizedTexts: [RecognizedText] = []
    // 번역된 텍스트를 저장하는 배열
    @State private var translatedTexts: [TranslatedText] = []
    // 오버레이 표시 여부
    @State private var showOverlay: Bool = false
    @State private var showTranslation: Bool = false // 번역 표시 여부
    @State private var sourceLanguage: Locale.Language = Locale.Language(identifier: "ko") // 원본 언어
    @State private var targetLanguage: Locale.Language = Locale.Language(identifier: "en") // 번역 언어
    @State private var isTranslating: Bool = false // 번역 중 여부
    @State private var translationConfiguration: TranslationSession.Configuration?
    
    var body: some View {
        // 언어 선택 UI
        // OCR 인식된 텍스트가 있으면 언어 선택 UI 표시
//        if !recognizedTexts.isEmpty{
            VStack{
                Text("번역 언어 설정")
                    .font(.headline)
                    .padding(.top)
                HStack {
                    Picker("Source", selection: $sourceLanguage) {
                        Text("한국어").tag(Locale.Language(identifier: "ko"))
                        Text("영어").tag(Locale.Language(identifier: "en"))
                    }
                    .pickerStyle(MenuPickerStyle())
                    Image(systemName: "arrow.right")
                        .padding(.horizontal)
                    Picker("Target", selection: $targetLanguage) {
                        Text("한국어").tag(Locale.Language(identifier: "ko"))
                        Text("영어").tag(Locale.Language(identifier: "en"))
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                // 사진 촬영 버튼
                HStack {
                    Button {
                        print("camera")
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("사진 촬영하기")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(width: 150, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.main, lineWidth: 3)
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white)))
                    }
                    
                    // 번역 버튼 - OCR 인식된 텍스트가 있으면 번역 버튼 표시
//                    if !recognizedTexts.isEmpty {
                    Button(action: {
                        translateTexts()
                    }) {
                        HStack {
                            // 번역 중 표시
                            if isTranslating {
                                ProgressView().scaleEffect(0.8)
                            }
                            Text(isTranslating ? "번역 중..." : "번역하기")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .fontWeight(.semibold)
                        }
                        .frame(width: 150, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.main, lineWidth: 3)
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                        )
                    }
                    .disabled(isTranslating)
//                        Button {
//                            print("camera")
//                        } label: {
//                            VStack(alignment: .leading, spacing: 10) {
//                                Text("번역하기")
//                                    .font(.system(size: 20))
//                                    .foregroundStyle(.black)
//                                    .fontWeight(.semibold)
//                            }
//                            .padding()
//                            .frame(width: 150, height: 70)
//                            .background(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .stroke(Color.main, lineWidth: 3)
//                                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white)))
//                        }
//                    }
                }
            }
//        }
    }
    
    // 번역 함수 수정
    private func translateTexts() {
        // OCR 인식된 텍스트가 있으면 번역 수행
        guard !recognizedTexts.isEmpty else { return }
        // 번역 중 표시
        isTranslating = true
        translatedTexts = []
        
        // TranslationSession.Configuration 설정
        if translationConfiguration == nil {
            translationConfiguration = TranslationSession.Configuration(
                source: sourceLanguage,
                target: targetLanguage
            )
        } else {
            // 기존 구성이 있으면 무효화하여 새로운 번역 트리거
            translationConfiguration?.invalidate()
        }
    }
    
    // 실제 번역 수행 함수
    private func performTranslations(using session: TranslationSession) async {
        do {
            // 번역 요청 생성
            let requests = recognizedTexts.enumerated().map { index, text in
                TranslationSession.Request(
                    sourceText: text.string,
                    clientIdentifier: "\(index)"
                )
            }
            
            var tempTranslatedTexts: [TranslatedText] = []
            
            // 배치 번역 수행
            for try await response in session.translate(batch: requests) {
                if let clientId = response.clientIdentifier,
                   let index = Int(clientId),
                   index < recognizedTexts.count {
                    
                    let translatedText = TranslatedText(
                        originalText: recognizedTexts[index].string,
                        translatedText: response.targetText,
                        boundingBox: recognizedTexts[index].boundingBox
                    )
                    
                    tempTranslatedTexts.append(translatedText)
                }
            }
            
            // UI 업데이트
            await MainActor.run {
                self.translatedTexts = tempTranslatedTexts.sorted { $0.boundingBox.minY < $1.boundingBox.minY }
                self.isTranslating = false
                self.showTranslation = true
                self.showOverlay = true
            }
            
        } catch {
            print("번역 오류: \(error)")
            await MainActor.run {
                self.isTranslating = false
                // 번역 실패 시 원본 텍스트를 표시
                let failedTranslations = recognizedTexts.map { text in
                    TranslatedText(
                        originalText: text.string,
                        translatedText: "[번역 실패: \(text.string)]",
                        boundingBox: text.boundingBox
                    )
                }
                self.translatedTexts = failedTranslations
                self.showTranslation = true
                self.showOverlay = true
            }
        }
    }
}

#Preview {
    TranslateAIView()
}
