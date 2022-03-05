//
//  ContentView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-02.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var unixTime = UnixTime(unixTimeText: GetUnixTimeString())
    @ObservedObject private var humanDate = DateObservableObject()
    @ObservedObject private var inputDate = DateObservableObject()
    
    var body: some View {
        ZStack(alignment: .top) {
            
            HStack {
                Divider()
            }
            .padding(EdgeInsets(top: 25, leading: 50, bottom: 25, trailing: 50))
            //.frame(height: 400)

            VStack {
                
                HStack {
                    
                    // Column 1
                    VStack {
                        Text("UNIX Epoch Time")
                            .font(.title2)
                            .padding(.bottom, 20)
                        
                        UnixTimeView(unixTime: self.unixTime)
                        .padding(.bottom, 10)
                        
                        // Button to convert from unix time to human readable timestamp
                        Button {
                            ConvertUnixTimeToHumanDate()
                        } label: {
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        .help("Convert to human readable date")
                    }
                    .padding()
                    .frame(width: 425)
                    
                    // Column 2
                    VStack {
                        Text("Human Readable Date")
                            .font(.title2)
                            .padding(.bottom, 20)
                        
                        DateTimeZoneView(dateObservableObject: self.humanDate)
                        .onAppear() {
                            // Make sure the unix time and this date match up on launch
                            ConvertUnixTimeToHumanDate()
                        }
                        
                        // Button to convert from human readable timestamp to unix time
                        Button {
                            ConvertHumanDateToUnixTime()
                        } label: {
                            Image(systemName: "arrow.left.circle.fill")
                        }
                        .padding(.top, 10)
                        .help("Convert to unix time")
                    }
                    .padding()
                    .frame(width: 425)
                    
                }
            
                HStack {
                    
                    // Column 1
                    VStack {
                        //DateView(dateObservableObject: inputDate)
                    }
                    .padding()
                    .frame(width: 425)
                    
                    // Column 2
                    VStack {
                        
                    }
                    .padding()
                    .frame(width: 425)
                }
                
            }
            .padding()
            
        }
    }
    
    func ConvertUnixTimeToHumanDate() {
        // Set date field. Take into account Time Zone.
        // First get date object based on the unix time text field
        let unixDateTime = Date(timeIntervalSince1970: Double(unixTime.unixTimeText) ?? 0)
        // Then adjust the date to the local time zone. We will always deal with unix time in our local time zone for simplicity.
        self.humanDate.date = unixDateTime.convert(from: TimeZone.current, to: TimeZone(identifier: self.humanDate.timeZoneSelection) ?? TimeZone.current)
        
        // Set seconds field
        let calendar = Calendar.current
        self.humanDate.seconds = String(calendar.component(.second, from: self.humanDate.date))
    }
    
    func ConvertHumanDateToUnixTime() {
        var calendar = Calendar.current
        let components = GetComponentsFromDate(dateParam: self.humanDate.date, secondsParam: self.humanDate.seconds, timeZone: TimeZone(identifier: self.humanDate.timeZoneSelection))
        calendar.timeZone = TimeZone(identifier: self.humanDate.timeZoneSelection) ?? TimeZone.current
        self.humanDate.date = calendar.date(from: components) ?? Date()
        self.unixTime.unixTimeText = GetUnixTimeString(dateParam: self.humanDate.date, fromTimeZone: TimeZone(identifier: self.humanDate.timeZoneSelection) ?? TimeZone.current)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func GetComponentsFromDate(dateParam: Date, secondsParam: String? = "0", timeZone: TimeZone? = TimeZone.current) -> DateComponents
{
    var calendar = Calendar.current
    calendar.timeZone = timeZone ?? TimeZone.current
    var components = DateComponents()
    components.day = calendar.component(.day, from: dateParam)
    components.month = calendar.component(.month, from: dateParam)
    components.year = calendar.component(.year, from: dateParam)
    components.hour = calendar.component(.hour, from: dateParam)
    components.minute = calendar.component(.minute, from: dateParam)
    components.second = Int(secondsParam ?? "0")
    return components
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
