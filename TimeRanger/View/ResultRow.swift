//
//  ResultRow.swift
//  TimeRanger
//
//  Created by Gattanjo Nilsson on 2024-11-06.
//
import SwiftUI

struct ResultRow: View {
    let result: TimeRangeResult

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Start: \(result.startTime), End: \(result.endTime)")
                Text("Target: \(result.targetTime)")
            }
            Spacer()
            Text(result.isWithinRange ? "Within Range" : "Out of Range")
                .foregroundColor(result.isWithinRange ? .green : .red)
        }
    }
}

#Preview {
    ResultRow(result: TimeRangeResult(startTime: 12, endTime: 13, targetTime: 12, isWithinRange: true))
}
