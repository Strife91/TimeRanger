//
//  TimeViewModel.swift
//  TimeRanger
//
//  Created by Gattanjo Nilsson on 2024-11-06.
//

import Foundation

class TimeViewModel: ObservableObject {
    // 時刻が範囲内にあるかどうかを表す列挙型。
    @Published var startTime: Int = 0
    @Published var endTime: Int = 0
    @Published var targetTime: Int = 0
    @Published var results: [TimeRangeResult] = []
    
    // 保存された結果があれば、それをロードして初期化する。
    init() {
        loadResults()
    }
    
    /// 指定された開始時間と終了時間の範囲内にターゲット時間が含まれているかを確認し、結果を保存します。
    ///
    /// この関数は、`checkIfTimeIsWithinRange`メソッドを使用して、`targetTime`が`startTime`と`endTime`で定義された範囲内にあるかを評価します。
    /// その後、開始時間、終了時間、ターゲット時間、範囲内に含まれているかどうかを記録する`TimeRangeResult`オブジェクトを作成します。
    /// この結果は`results`配列に追加され、永続的に保存されます。
    ///
    /// - 参照: 時間範囲の確認方法については `checkIfTimeIsWithinRange(startTime:endTime:targetTime:)` を参照してください。

    func checkAndSaveResult() {
        let isWithinRange = checkIfTimeIsWithinRange(startTime: startTime, endTime: endTime, targetTime: targetTime)
        let result = TimeRangeResult(startTime: startTime, endTime: endTime, targetTime: targetTime, isWithinRange: isWithinRange)
        results.insert(result, at: 0)
        saveResults()
    }
    
    /// 指定された時間範囲内にターゲット時間が含まれているかを確認します。
    ///
    /// この関数は、`targetTime`が`startTime`と`endTime`で定義された範囲内にあるかを確認します。
    /// 標準的な範囲（開始時間が終了時間よりも小さい場合）と、夜間にまたがる範囲（開始時間が終了時間よりも大きい場合）の両方に対応しています。
    /// - パラメータ:
    ///   - startTime: 時間範囲の開始時刻（24時間形式）。
    ///   - endTime: 時間範囲の終了時刻（24時間形式）。
    ///   - targetTime: チェックする対象の時間（24時間形式）。
    /// - 戻り値: `targetTime`が範囲内にある場合は`true`、それ以外の場合は`false`を返します。
    ///
    func checkIfTimeIsWithinRange(startTime: Int, endTime: Int, targetTime: Int) -> Bool {
        if startTime < endTime {
            return targetTime >= startTime && targetTime < endTime
        } else if startTime > endTime {
            return targetTime >= startTime || targetTime < endTime
        } else {
            return targetTime == startTime
        }
    }
    
    /// 永続ストレージから以前に保存された結果を読み込み、`results`配列を更新します。
    ///
    /// この関数は、キー`"savedResults"`で`UserDefaults`に保存されたデータを取得します。
    /// データが見つかった場合、`JSONDecoder`を使用してそのデータを`TimeRangeResult`オブジェクトの配列にデコードしようとします。
    /// デコードが成功した場合、その結果を`results`配列に代入し、アプリ起動時に前回の結果が復元されるようにします。
    ///
    /// - 重要事項:
    ///   - データが見つからない、またはデコードに失敗した場合、`results`は変更されません。
    ///
    /// - 参照: 対応する保存機能については`saveResults()`を参照してください。

    func loadResults() {
        if let savedData = UserDefaults.standard.data(forKey: "savedResults"),
           let decodedResults = try? JSONDecoder().decode([TimeRangeResult].self, from: savedData) {
            results = decodedResults
        }
    }
    
    /// 現在の`results`配列を永続ストレージに保存します。
    ///
    /// この関数は、`TimeRangeResult`オブジェクトを含む`results`配列を`JSONEncoder`を使ってJSON形式にエンコードします。
    /// エンコードが成功した場合、結果のデータはキー`"savedResults"`で`UserDefaults`に保存されます。
    /// これにより、アプリのセッション間でデータが永続されます。
    ///
    /// - 重要事項:
    ///   - エンコードが失敗した場合、データは保存されず、`UserDefaults`は変更されません。
    ///
    /// - 参照: 永続ストレージから保存された結果を読み込む機能については`loadResults()`を参照してください。

    func saveResults() {
        if let encodedData = try? JSONEncoder().encode(results) {
            UserDefaults.standard.set(encodedData, forKey: "savedResults")
        }
    }
}
