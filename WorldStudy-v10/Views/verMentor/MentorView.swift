//
//  MentiView.swift
//  World Study1
//
//  Created by 이다은 on 5/23/25.
//

import SwiftUI

struct MentorView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var rankingViewModel = RankingViewModel()
    
    let backgroundColor = Color("BackgroundColor")
    
    var body: some View {
        let name = authViewModel.name ?? "사용자"
        let role = authViewModel.role ?? "멘토"
        
        NavigationView{
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack {
                    Text("\(role)")
                        .padding(.top, 150)
                        .padding(.leading, -175)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("안녕하세요. \(name) 님")
                            .font(.system(size: 30))
                            .fontWeight(.heavy)
                            .padding(.leading, 20)
                        Image("together")
                            .padding(.leading, -10)
                    }
                    .padding(.top, -40)
                    
                    rankingSection
                    
                    NavigationLink(destination: HelpAiView()) { // 이동 view 수정 !!
                        VStack {
                            HStack {
                                Text("질문 보러가기")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                                    .fontWeight(.heavy)
                                Spacer()
                                Image("nextBtn")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }
                            .padding(.bottom, 10)
                            
                            Text("다문화 친구들의 궁금증에 멘토님들의 경험을 나눠주세요.")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        .padding()
                        .frame(width: 350, height: 110)
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.vertical)
                    }
                }
                .padding(.bottom, 100)
                .onAppear {
                    rankingViewModel.loadRankings()
                }
            }
        }
    }
    
    var rankingSection: some View {
        VStack(alignment: .center, spacing: 15) {
            Text("실시간 멘토 답변 랭킹")
                .font(.title3)
                .fontWeight(.bold)
            Text("개인별 답변 개수로 순위가 산정됩니다")
                .font(.caption)
                .foregroundColor(.gray)
            
            if rankingViewModel.isLoading {
                ProgressView()
            } else if let error = rankingViewModel.errorMessage {
                Text(error).foregroundColor(.red)
            } else {
                ForEach(Array(rankingViewModel.rankings.prefix(3).enumerated()), id: \.offset) { index, mentor in
                    HStack {
                        Image(rankIcon(for: index))
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(rankLabel(for: index))
                            .fontWeight(.semibold)
                            .frame(width: 40)
                        Text(mentor.name)
                        Spacer()
                        Text("\(mentor.count)개")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .frame(width: 350)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.main, lineWidth: 3)
                .background(
                    RoundedRectangle(cornerRadius: 16).fill(Color.white)
                )
        )
        .padding(.top, -30)
    }
    
    func rankIcon(for index: Int) -> String {
        switch index {
        case 0: return "first"
        case 1: return "second"
        case 2: return "third"
        default: return "star"
        }
    }
    
    func rankLabel(for index: Int) -> String {
        switch index {
        case 0: return "1등"
        case 1: return "2등"
        case 2: return "3등"
        default: return "-"
        }
    }
}

#Preview {
    MentorView(authViewModel: AuthViewModel())
}
