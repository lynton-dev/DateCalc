//
//  UnixTimeView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-04.
//

import SwiftUI

struct UnixTimeView: View {
    @StateObject var unixTime: UnixTime

    var body: some View {
        HStack {
            Text("Unix epoch time:")
            
            TextField("Enter Unix timestamp", text: $unixTime.unixTimeText)
            .frame(width: 150)
            
            // Reset unix time button
            ResetButton(help: "Reset to current time") {
                self.unixTime.unixTimeText = GetUnixTimeString()
            }
            .padding(.leading, 5)
        }
    }
}

struct UnixTimeView_Previews: PreviewProvider {
    static var previews: some View {
        UnixTimeView(unixTime: UnixTime(unixTimeText: GetUnixTimeString()))
    }
}

class UnixTime: ObservableObject {
    @Published var unixTimeText: String
    
    init(unixTimeText: String) {
        self.unixTimeText = unixTimeText
    }
}

func GetUnixTimeString(dateParam: Date? = nil, fromTimeZone: TimeZone? = TimeZone.current) -> String {
    var date = dateParam ?? Date()
    // Adjust date to our local time zone. We will always deal with unix time in our local time zone for simplicity.
    date = date.convert(from: fromTimeZone ?? TimeZone.current, to: TimeZone.current)
    
    return String(format: "%.0f", date.timeIntervalSince1970.rounded())
}
