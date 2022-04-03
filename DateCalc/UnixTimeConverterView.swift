//
//  UnixTimeConverterView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-18.
//

import SwiftUI

struct UnixTimeConverterView: View {
    @Environment(\.colorScheme) var colorScheme
    private let minColumnWidth = 375.0
    
    @StateObject private var unixTime = UnixTime(unixTimeText: GetUnixTimeString())
    @StateObject private var humanDate = DateObservableObject()
    
    var body: some View {
        ZStack(alignment: .center) {
            
            HStack {
                Divider()
            }.padding()
            
            VStack {
                
                // Button to convert from unix time to human readable timestamp
                Button(action: {
                    ConvertUnixTimeToHumanDate()
                }) {
                    Image(systemName: "arrow.right.square.fill")
                        .symbolRenderingMode(.multicolor)
                        .resizable()
                        .frame(width: 35, height: 35)

                }
                .background(Color(NSColor.windowBackgroundColor))
                .foregroundColor(colorScheme == .dark ? Color("DarkButtonBackground") : .accentColor)
                .buttonStyle(.plain)
                .help("Convert to human readable date")
            
                // Button to convert from human readable timestamp to unix time
                Button(action: {
                    ConvertHumanDateToUnixTime()
                }) {
                    Image(systemName: "arrow.left.square.fill")
                        .symbolRenderingMode(.multicolor)
                        .resizable()
                        .frame(width: 35, height: 35)

                }
                .background(Color(NSColor.windowBackgroundColor))
                .foregroundColor(colorScheme == .dark ? Color("DarkButtonBackground") : .accentColor)
                .buttonStyle(.plain)
                .padding(.top, 5)
                .help("Convert to unix time")
                
            }
                
            HStack {
                
                // Column 1
                VStack {
                    
                    UnixTimeView(unixTime: self.unixTime)
                    .padding(.bottom, 10)
                    
                }
                .frame(minWidth: self.minColumnWidth)
                .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 75))
                
                // Column 2
                VStack {
                    
                    DateTimeZoneView(dateObservableObject: self.humanDate)
                    .onAppear() {
                        // Make sure the unix time and this date match up on launch
                        ConvertHumanDateToUnixTime()
                    }
                    
                }
                .frame(minWidth: self.minColumnWidth)
                .padding(EdgeInsets(top: 0, leading: 75, bottom: 0, trailing: 25))
                
            }
            
        }
    }
    
    /// Convert the unix time to a human readable datetime
    func ConvertUnixTimeToHumanDate() {
        // Set date field. Take into account Time Zone.
        // First get date object based on the unix time text field
        let unixDateTime = Date(timeIntervalSince1970: Double(unixTime.unixTimeText) ?? 0)
        // Then adjust the date to the local time zone. We will always deal with unix time in our local time zone for simplicity.
        self.humanDate.date = unixDateTime.convert(from: TimeZone.current, to: GetTimeZoneFromCustomIdentifier(customIdentifier: self.humanDate.timeZoneSelection))
        
        // Set seconds field
        let calendar = Calendar.current
        self.humanDate.seconds = String(calendar.component(.second, from: self.humanDate.date))
    }


    /// Convert the human readable time to unix time
    func ConvertHumanDateToUnixTime() {
        var calendar = Calendar.current
        let timeZone = GetTimeZoneFromCustomIdentifier(customIdentifier: self.humanDate.timeZoneSelection)
        let components = GetComponentsFromDate(dateParam: self.humanDate.date, secondsParam: self.humanDate.seconds, timeZone: timeZone)
        calendar.timeZone = timeZone
        self.humanDate.date = calendar.date(from: components) ?? Date()
        self.unixTime.unixTimeText = GetUnixTimeString(dateParam: self.humanDate.date, fromTimeZone: timeZone)
    }
    
}

struct UnixTimeConverterView_Previews: PreviewProvider {
    static var previews: some View {
        UnixTimeConverterView()
    }
}
