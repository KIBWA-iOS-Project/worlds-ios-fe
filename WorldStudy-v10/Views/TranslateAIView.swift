
import SwiftUI
import Vision
import PhotosUI
import Translation

// OCR 인식된 텍스트를 저장하는 모델
struct RecognizedText: Identifiable {
    let id = UUID()
    let string: String
    let boundingBox: CGRect
}

// 번역된 텍스트를 저장하는 모델
struct TranslatedText: Identifiable {
    let id = UUID()
    let originalText: String
    let translatedText: String
    let boundingBox: CGRect
}

struct TranslateAIView: View {
    // 카메라 뷰모델
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // OCR 인식된 텍스트를 저장하는 배열
    @State private var recognizedTexts: [RecognizedText] = []
    // 번역된 텍스트를 저장하는 배열
    @State private var translatedTexts: [TranslatedText] = []
    // 오버레이 표시 여부
    @State private var showOverlay: Bool = false
    // OCR 처리된 이미지를 저장
    @State private var processedImage: UIImage? // OCR 처리된 이미지를 저장
    @State private var showTranslation: Bool = false // 번역 표시 여부
    @State private var sourceLanguage: Locale.Language = Locale.Language(identifier: "ko") // 원본 언어
    @State private var targetLanguage: Locale.Language = Locale.Language(identifier: "en") // 번역 언어
    @State private var isTranslating: Bool = false // 번역 중 여부
    @State private var translationConfiguration: TranslationSession.Configuration?

    @State private var isShowingFullScreen = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 상단 로고 및 텍스트
                    if selectedImage == nil {
                        VStack {
                            Image("logoApp")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 180)
                                .padding(.top, 40)
                            Text("AI 번역 도우미")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 20)
                        }
                    }

                    // 언어 설정 선택
                    if !recognizedTexts.isEmpty {
                        languagePickerSection
                    }

                    // 이미지 + 오버레이
                    ZStack {
                        // 선택한 이미지 표시
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .padding()
                                .onTapGesture {
                                    isShowingFullScreen = true
                                }
                        } else {
                            // 이미지 없을 때 기본 안내 박스
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                .frame(height: 200)
                                .overlay(Text("이미지를 선택해주세요").foregroundColor(.gray))
                        }

                        // 오버레이 텍스트 표시
                        if showOverlay, let image = selectedImage {
                            GeometryReader { geometry in
                                ZStack {
                                    if showTranslation {
                                        ForEach(translatedTexts) { text in
                                            Text(text.translatedText)
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                                .background(Color.white.opacity(0.8))
                                                .position(
                                                    x: text.boundingBox.midX * geometry.size.width,
                                                    y: text.boundingBox.midY * geometry.size.height
                                                )
                                        }
                                    } else {
                                        ForEach(recognizedTexts) { text in
                                            Text(text.string)
                                                .font(.caption)
                                                .foregroundColor(.black)
                                                .padding(2)
                                                .background(Color.white.opacity(0.7))
                                                .position(
                                                    x: text.boundingBox.midX * geometry.size.width,
                                                    y: text.boundingBox.midY * geometry.size.height
                                                )
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 250)
                    
                    // 전체 화면 이미지 보기
                    .fullScreenCover(isPresented: $isShowingFullScreen) {
                        if let image = selectedImage {
                            ZStack(alignment: .topLeading) {
                                GeometryReader { geometry in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .ignoresSafeArea()

                                    if showOverlay {
                                        if showTranslation {
                                            ForEach(translatedTexts) { text in
                                                Text(text.translatedText)
                                                    .font(.caption)
                                                    .foregroundColor(.blue)
                                                    .background(Color.white.opacity(0.8))
                                                    .position(
                                                        x: text.boundingBox.midX * geometry.size.width,
                                                        y: text.boundingBox.midY * geometry.size.height
                                                    )
                                            }
                                        } else {
                                            ForEach(recognizedTexts) { text in
                                                Text(text.string)
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                                    .background(Color.white.opacity(0.8))
                                                    .position(
                                                        x: text.boundingBox.midX * geometry.size.width,
                                                        y: text.boundingBox.midY * geometry.size.height
                                                    )
                                            }
                                        }
                                    }
                                }
                                Button(action: {
                                    isShowingFullScreen = false
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.black)
                                        .padding()
                                }
                            }
                        }
                    }

                    // 버튼 영역
                    HStack(spacing: 16) {
                        Menu {
                            Button("카메라") {
                                imagePickerSourceType = .camera
                                isShowingImagePicker = true
                            }
                            Button("앨범") {
                                imagePickerSourceType = .photoLibrary
                                isShowingImagePicker = true
                            }
                        } label: {
                            Text("사진 선택")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.main, lineWidth: 3)
                                )
                                .cornerRadius(8)
                        }

                        Button("사진 읽기") {
                            if let image = selectedImage {
                                let imageToProcess = resizeImage(image, targetSize: CGSize(width: 1024, height: 1024)) ?? image
                                recognizeText(from: imageToProcess)
                            }
                        }
                        .buttonStyle(MainButtonStyle())
                        .disabled(selectedImage == nil)

                        if !recognizedTexts.isEmpty {
                            Button(isTranslating ? "번역 중..." : "번역하기") {
                                translateTexts()
                            }
                            .buttonStyle(MainButtonStyle(filled: true))
                            .disabled(isTranslating)
                        }
                    }

                    // 결과 텍스트 박스
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            if showTranslation && !translatedTexts.isEmpty {
                                ForEach(translatedTexts) { text in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("원문: \(text.originalText)").font(.subheadline)
                                        Text("번역: \(text.translatedText)").font(.subheadline).foregroundColor(.blue)
                                    }
                                    Divider()
                                }
                            } else {
                                ForEach(recognizedTexts) { text in
                                    Text(text.string).padding(.horizontal)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding()
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePickerView(selectedImage: $selectedImage, sourceType: imagePickerSourceType)
                }
                .translationTask(translationConfiguration) { session in
                    await performTranslations(using: session)
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    // 언어 선택 picker
    var languagePickerSection: some View {
        VStack(spacing: 10) {
            Text("언어 설정").font(.headline)
            HStack {
                Picker("원본", selection: $sourceLanguage) {
                    Text("한국어").tag(Locale.Language(identifier: "ko"))
                }
                .pickerStyle(.menu)

                Image(systemName: "arrow.right")

                Picker("대상", selection: $targetLanguage) {
                    Text("영어").tag(Locale.Language(identifier: "en"))
                    Text("중국어").tag(Locale.Language(identifier: "zh-Hans"))
                    Text("베트남어").tag(Locale.Language(identifier: "vi"))
                    Text("일본어").tag(Locale.Language(identifier: "ja"))
                    Text("스페인어").tag(Locale.Language(identifier: "es"))
                }
                .pickerStyle(.menu)
            }
        }
    }

    // 번역 시작
    private func translateTexts() {
        guard !recognizedTexts.isEmpty else { return }
        isTranslating = true
        translatedTexts = []
        if translationConfiguration == nil {
            translationConfiguration = TranslationSession.Configuration(source: sourceLanguage, target: targetLanguage)
        } else {
            translationConfiguration?.invalidate()
        }
    }

    // 실제 번역 실행
    private func performTranslations(using session: TranslationSession) async {
        do {
            let requests = recognizedTexts.enumerated().map { index, text in
                TranslationSession.Request(sourceText: text.string, clientIdentifier: "\(index)")
            }

            var tempTranslatedTexts: [TranslatedText] = []

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

            await MainActor.run {
                self.translatedTexts = tempTranslatedTexts
                self.isTranslating = false
                self.showTranslation = true
                self.showOverlay = true
            }
        } catch {
            await MainActor.run {
                self.translatedTexts = recognizedTexts.map {
                    TranslatedText(originalText: $0.string, translatedText: "[번역 실패]", boundingBox: $0.boundingBox)
                }
                self.isTranslating = false
                self.showTranslation = true
                self.showOverlay = true
            }
        }
    }

    // OCR 텍스트 인식
    private func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { req, error in
            guard let observations = req.results as? [VNRecognizedTextObservation], error == nil else { return }
            let texts = observations.compactMap { obs -> RecognizedText? in
                guard let top = obs.topCandidates(1).first else { return nil }
                let box = obs.boundingBox
                let transformedBox = CGRect(x: box.minX, y: 1 - box.maxY, width: box.width, height: box.height)
                return RecognizedText(string: top.string, boundingBox: transformedBox)
            }
            DispatchQueue.main.async {
                self.recognizedTexts = texts
                self.translatedTexts = []
                self.showOverlay = true
                self.showTranslation = false
            }
        }
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR", "en-US"]
        try? handler.perform([request])
    }

    // 이미지 리사이즈
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    // 상태 초기화
    private func cleanupMemory() {
        processedImage = nil
        recognizedTexts = []
        translatedTexts = []
        showOverlay = false
        showTranslation = false
    }
}

// 버튼 스타일
struct MainButtonStyle: ButtonStyle {
    var filled: Bool = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(filled ? Color.blue : Color.white)
            .foregroundColor(filled ? .white : .black)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.main, lineWidth: 3)
            )
            .cornerRadius(8)
    }
}

#Preview {
    TranslateAIView()
}
