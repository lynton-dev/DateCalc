//
//  ContentView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-02.
//

import SwiftUI

struct ContentView: View {
    @State private var unixTimeText = GetUnixTimeString()
    @State private var date = Date()
    @State private var seconds = "0"
    let calendar = Calendar.current
    
    var body: some View {
        HStack {
            
            // Column 1
            VStack {
                HStack {
                    Text("Unix time")
                    
                    TextField("Enter unix time", text: $unixTimeText)
                    .frame(width: 150)
                    
                    Button {
                        self.unixTimeText = GetUnixTimeString()
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    .help("Reset to current time")
                        .padding(.trailing, 20)
                }
                .padding(.bottom, 10)
                
                Button {
                    self.date = Date(timeIntervalSince1970: Double(unixTimeText) ?? 0)
                    self.seconds = String(calendar.component(.second, from: date))
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                }
                .help("Convert to human readable time")
            }
            .padding()
            .frame(width: 350)
            
            HStack {
                Divider()
                    .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
            }
            
            // Column 2
            VStack {
                HStack {
                    DatePicker(
                            "Human time",
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.field)
                    .frame(width: 235)
                    
                    TextField("", text: $seconds)
                    .onAppear() {
                        self.seconds = String(calendar.component(.second, from: self.date))
                    }
                    .frame(width: 25)
                    
                    Text("sec")
                }
                .padding(.bottom, 10)
            
                Button {
                    var components = DateComponents()
                    components.day = calendar.component(.day, from: self.date)
                    components.month = calendar.component(.month, from: self.date)
                    components.year = calendar.component(.year, from: self.date)
                    components.hour = calendar.component(.hour, from: self.date)
                    components.minute = calendar.component(.minute, from: self.date)
                    components.second = Int(seconds)
                    self.date = calendar.date(from: components) ?? Date()
                    unixTimeText = GetUnixTimeString(dateParam: self.date)
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                }
                .help("Convert to unix time")
            }
            .padding()
            .frame(width: 350)
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func GetUnixTimeString(dateParam: Date? = nil) -> String {
    let date = dateParam ?? Date()
    return String(format: "%.0f", date.timeIntervalSince1970.rounded())
}
