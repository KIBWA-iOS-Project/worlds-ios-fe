//
//  ContentView.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 5/23/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("메인페이지")
                .tabItem {
                    Image(systemName: "globe.asia.australia.fill")
                    Text("홈")
                }
            Text("커뮤니티")
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("커뮤니티")
                }
            MyPageMentor()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("마이페이지")
                }
            
            QuestionViewMentee(viewModel: QBoardViewModel())
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("멘티확인용")
                }
            QuestionViewMentor(viewModel: QBoardViewModel())
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("멘토확인용")
                }
        }
    }
}

#Preview {
    ContentView()
}
