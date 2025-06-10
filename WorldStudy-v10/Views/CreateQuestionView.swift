//
//  CreateQuestionView.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/27/25.
//

import SwiftUI

struct CreateQuestionView: View {
    @Binding var title: String
    @Binding var content: String
    @Binding var isPresented: Bool
    @Binding var isCreating: Bool
    @Binding var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode
//    @State private var goToQuestionView = false
    
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var onSubmit: (UIImage?) -> Void

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
//                NavigationLink(destination: QuestionView(), isActive: $goToQuestionView) {
//                                   EmptyView()
//                               }
//                               .hidden()
                
                Text("멘토에게 질문하기💬")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 25)

                TextField("제목", text: $title)
                    .padding(12)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("mainColor"), lineWidth: 2)
                    )
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(8)
                                .padding(.leading, 30)
                        }
                
                Menu("사진 추가하기") {
                      Button("Camera") {
                          imagePickerSourceType = .camera
                          isShowingImagePicker = true
                      }
                      Button("Photo") {
                          imagePickerSourceType = .photoLibrary
                          isShowingImagePicker = true
                      }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 30)

                TextEditor(text: $content)
                    .padding(10)
                    .frame(height: 150)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("mainColor"), lineWidth: 2)
                    )
                    .cornerRadius(10)
                    .padding(.horizontal)

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                //등록 중 로딩
                if isCreating {
                    ProgressView()
                }

                Button {
                    onSubmit(selectedImage)
                } label: {
                    Text("등록")
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                        .padding()
                        .frame(width: 150)
                        .background(Color("BackgroundColor2"))
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 0)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 30)

                Spacer()
            }
            .padding()
            .navigationTitle("월스")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() //지금화면 닫고 이전 화면가기
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                            .padding(.leading, 15)
                            .frame(width: 20, height: 30)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePickerView(selectedImage: $selectedImage, sourceType: imagePickerSourceType)
        }
    }
}
