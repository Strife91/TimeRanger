//
//  ContentView.swift
//  TimeRanger
//
//  Created by Gattanjo Nilsson on 2024-11-06.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimeViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 開始時間、終了時間、目標時間のピッカー
                TimePickerField(title: "Start Time", time: $viewModel.startTime)
                TimePickerField(title: "End Time", time: $viewModel.endTime)
                TimePickerField(title: "Target Time", time: $viewModel.targetTime)

                // 範囲をチェックして結果を保存するボタン
                Button(action: viewModel.checkAndSaveResult) {
                    Text("Check Range")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // 結果一覧
                List(viewModel.results) { result in
                    ResultRow(result: result)
                }
            }
            .padding()
            .navigationTitle("Time Range Checker")
        }
    }
}

#Preview {
    ContentView()
}
