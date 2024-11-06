//
//  TimePickerField.swift
//  TimeRanger
//
//  Created by Gattanjo Nilsson on 2024-11-06.
//

import SwiftUI

struct TimePickerField: View {
    let title: String
    @Binding var time: Int
    @State private var isPickerPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            
            // ピッカーを表示するボタン
            Button(action: {
                isPickerPresented = true
            }) {
                HStack {
                    Text("\(time):00")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
            }
            .sheet(isPresented: $isPickerPresented) {
                VStack {
                    Text("Select \(title)")
                        .font(.headline)
                        .padding()
                    
                    Picker("Select \(title)", selection: $time) {
                        ForEach(0..<24) { hour in
                            Text("\(hour):00").tag(hour)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(WheelPickerStyle())
                    
                    // ピッカーを解除するボタン
                    Button("Done") {
                        isPickerPresented = false
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    StateWrapper()
}

struct StateWrapper: View {
    @State private var time: Int = 0
    
    var body: some View {
        TimePickerField(title: "Start Time", time: $time)
    }
}
