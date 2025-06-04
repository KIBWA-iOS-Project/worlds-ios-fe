//
//  RankingViewModel.swift
//  Login1
//
//  Created by 이다은 on 6/1/25.
//

import Foundation

class RankingViewModel: ObservableObject {
    @Published var rankings: [MentorRanking] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadRankings() {
        Task {
            await MainActor.run { self.isLoading = true }

            do {
                let fetched = try await APIService.shared.fetchMentorRankings()
                await MainActor.run {
                    self.rankings = fetched
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "랭킹 데이터를 불러오지 못했습니다."
                    self.isLoading = false
                }
            }
        }
    }
}
