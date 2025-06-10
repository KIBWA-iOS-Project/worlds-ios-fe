//
//  LaunchView.swift
//  WorldStudy-v10
//
//  Created by 이서하 on 6/9/25.
//

import SwiftUI

struct LaunchView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            ContentView() // 이미 정의된 ContentView 사용
        } else {
            Image("LaunchImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
        }
    }
}

