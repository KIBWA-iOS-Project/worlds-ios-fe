//
//  HelpAiView.swift
//  WorldStudy-v10
//
//  Created by 이다은 on 6/4/25.
//

import SwiftUI
import TipKit

// 1. TipKit 팁 정의
struct HelpTip: Tip {
    var title: Text {
        Text("더 정확한 인식을 위해 이렇게 촬영해주세요!")
    }
    
    var message: Text? {
        Text("1. 텍스트가 또렷하게 보이도록 흔들리지 않게 촬영 해주세요!\n")
        + Text("2. 문서 전체가 프레임 안에 잘 들어오도록 해주세요!")
    }
}

struct HelpAiView: View {
    init() {
        try? Tips.configure() // 2. TipKit 설정
    }
    
    let backgroundColor = Color("BackgroundColor")
    private let helpTip = HelpTip() // 팁 인스턴스
    var body: some View {
        ZStack{
            Color(backgroundColor).ignoresSafeArea()
            VStack {
                HStack{
                    Button {
                        
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "questionmark.circle")
                                .foregroundStyle(.gray)
                            Text("도움말 보기")
                                .foregroundStyle(.gray)
                        }
                    }
                    .popoverTip(helpTip)
                    .padding(.top)
                }
                .padding(.leading, 170)
                Button {
                    print("camera")
                } label: {
                    ZStack {
                        Image("camera")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .frame(width: 300, height: 250)
                            .border(.main, width: 8)
                            .cornerRadius(10)
                        Text("텍스트를 인식하려면 사진 촬영을 해주세요")
                            .padding(.top, 120)
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                    }
                    .padding(.bottom, 250)
                }
            }
        }
    }
}

#Preview {
    HelpAiView()
}
