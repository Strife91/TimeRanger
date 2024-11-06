//
//  TimeRangeResult.swift
//  TimeRanger
//
//  Created by Gattanjo Nilsson on 2024-11-06.
//

import SwiftUI

struct TimeRangeResult: Identifiable, Codable {
    var id = UUID()
    let startTime: Int
    let endTime: Int
    let targetTime: Int
    let isWithinRange: Bool
}
