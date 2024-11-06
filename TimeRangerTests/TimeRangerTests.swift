//
//  TimeRangerTests.swift
//  TimeRangerTests
//
//  Created by Gattanjo Nilsson on 2024-11-06.
//

import Testing
import Foundation

@testable import TimeRanger

struct TimeRangerTests {

    let viewModel = TimeViewModel()
    
    @Test(arguments:[
        (startTime: 8, endTime: 17, targetTime: 10, expectedResult: true), // 範囲内
        (startTime: 8, endTime: 17, targetTime: 18, expectedResult: false), // 範囲外
        (startTime: 22, endTime: 5, targetTime: 2, expectedResult: true), // 真夜中を越える
        (startTime: 8, endTime: 17, targetTime: 8, expectedResult: true), // 開始時間と同じ
        (startTime: 8, endTime: 17, targetTime: 17, expectedResult: false), // 終了時間と同じ
        (startTime: 10, endTime: 10, targetTime: 10, expectedResult: true) // // 開始時間と終了時間が同じ
    ])
    func timeIsWithinRange(startTime: Int, endTime: Int, targetTime: Int, expectedResult: Bool) async throws {
        #expect(viewModel.checkIfTimeIsWithinRange(startTime: startTime, endTime: endTime, targetTime: targetTime) == expectedResult)
    }
    
    @Test(arguments: [
        (startTime: 8, endTime: 17, targetTime: 10, expectedResult: true), // 範囲内
        (startTime: 8, endTime: 17, targetTime: 18, expectedResult: false), // 範囲外
        (startTime: 22, endTime: 5, targetTime: 2, expectedResult: true) // 真夜中を越える
    ])
    func checkAndSaveResult(startTime: Int, endTime: Int, targetTime: Int, expectedResult: Bool) async throws {
        viewModel.startTime = startTime
        viewModel.endTime = endTime
        viewModel.targetTime = targetTime
        viewModel.checkAndSaveResult()
        
        let result = try #require(viewModel.results.first)
        #expect(result.startTime == startTime)
        #expect(result.endTime == endTime)
        #expect(result.targetTime == targetTime)
        #expect(result.isWithinRange == expectedResult)
    }
    
    @Test
    func saveResults() throws {
        let result = TimeRangeResult(startTime: 8, endTime: 17, targetTime: 10, isWithinRange: true)
        viewModel.results = [result]
        
        viewModel.saveResults()
        
        let savedData = try #require(UserDefaults.standard.data(forKey: "savedResults"))
        let decodedResults = try? JSONDecoder().decode([TimeRangeResult].self, from: savedData)
        #expect(decodedResults?.count == 1)
        #expect(decodedResults?.first?.startTime == 8)
        #expect(decodedResults?.first?.endTime == 17)
        #expect(decodedResults?.first?.targetTime == 10)
        #expect(decodedResults?.first?.isWithinRange == true)
    }
    
    @Test
    func loadResults() {
        let result = TimeRangeResult(startTime: 8, endTime: 17, targetTime: 10, isWithinRange: true)
        let encodedData = try? JSONEncoder().encode([result])
        UserDefaults.standard.set(encodedData, forKey: "savedResults")
        
        viewModel.loadResults()
        
        #expect(viewModel.results.count == 1)
        #expect(viewModel.results.first?.startTime == 8)
        #expect(viewModel.results.first?.endTime == 17)
        #expect(viewModel.results.first?.targetTime == 10)
        #expect(viewModel.results.first?.isWithinRange == true)
    }
}
