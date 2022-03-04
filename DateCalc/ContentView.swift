//
//  ContentView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-02.
//

import SwiftUI

struct ContentView: View {
    @State private var unixTimeText = GetCurrentUnixTimeString()
    @State private var date = Date()
    @State private var seconds = "0"
    @State private var previousSeconds = "0"
    @State private var timeZoneSelection = TimeZone.current.identifier
    @State private var previousTimeZoneSelection = TimeZone.current.identifier
    let timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
    
    var body: some View {
        HStack {
            
            // Column 1
            VStack {
                HStack {
                    Text("Unix time:")
                    
                    TextField("Enter unix time", text: $unixTimeText)
                    .frame(width: 150)
                    
                    // Reset unix time button
                    Button {
                        self.unixTimeText = GetUnixTimeString()
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    .help("Reset to current time")
                    .padding(.leading, 5)
                }
                .padding(.bottom, 10)
                
                // Convert from unix time to human readable timestamp
                Button {
                    ConvertUnixTimeToHumanDate()
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                }
                .help("Convert to human readable time")
            }
            .padding()
            .frame(width: 400)
            
            HStack {
                Divider()
                    .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
            }
            
            // Column 2
            VStack {
                HStack {
                    DatePicker(
                            "Human time:",
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute]
                    )
                    .onAppear()
                    {
                        // Make sure the unix time and this date match up on launch
                        ConvertUnixTimeToHumanDate()
                    }
                    .datePickerStyle(.field)
                    .frame(width: 235)
                    
                    // Seconds text field
                    TextField("", text: $seconds)
                    .onChange(of: self.seconds) { newValue in
                        // Seconds field validation
                        if (self.seconds.isEmpty || !self.seconds.isNumber) {
                            self.seconds = "0"
                            return
                        }
                        
                        let secondsInt = Int(self.seconds) ?? 0
                        if (secondsInt < 0 || secondsInt >= 60) {
                            self.seconds = self.previousSeconds
                        } else {
                            self.previousSeconds = self.seconds
                        }
                    }
                    .onAppear() {
                        // Extract seconds from date and update seconds text field
                        UpdateSecondsFromDate()
                    }
                    .frame(width: 25)
                    
                    Text("sec")
                        .padding(.leading, -5)
                    
                    // Reset date button
                    Button {
                        ResetDate()
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    .help("Reset to current time")
                    .padding(.leading, 5)
                }
                .padding(.bottom, 10)
                
                HStack {
                    // Select Time Zone
                    Picker("Time Zone", selection: $timeZoneSelection) {
                        ForEach(self.timeZoneIdentifiers, id: \.self) {
                            Text($0)
                        }
                    }.onChange(of: self.timeZoneSelection) { newValue in
                        // Adjust date from previously selected time zone to the newly selected time zone
                        self.date = self.date.convert(from: TimeZone(identifier: self.previousTimeZoneSelection)!, to: TimeZone(identifier: self.timeZoneSelection)!)
                        
                        // Store this as our new previous time zone selection
                        self.previousTimeZoneSelection = self.timeZoneSelection
                    }
                    
                    // Reset time zone button
                    Button {
                        ResetTimeZone()
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    .help("Reset to local time zone")
                    .padding(.leading, 5)
                }
                .padding(.bottom, 10)
            
                // Convert from human readable timestamp to unix time
                Button {
                    ConvertHumanDateToUnixTime()
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                }
                .help("Convert to unix time")
            }
            .padding()
            .frame(width: 400)
            
        }
        .padding()
    }
    
    func ResetDate() {
        self.date = Date()
        UpdateSecondsFromDate()
    }
    
    func ResetTimeZone() {
        self.timeZoneSelection = TimeZone.current.identifier
    }
    
    func ConvertUnixTimeToHumanDate() {
        // Set date field. Take into account Time Zone.
        // First get date object based on the unix time text field
        let unixDateTime = Date(timeIntervalSince1970: Double(unixTimeText) ?? 0)
        // Then adjust the date to the local time zone. We will always deal with unix time in our local time zone for simplicity.
        self.date = unixDateTime.convert(from: TimeZone.current, to: TimeZone(identifier: self.timeZoneSelection) ?? TimeZone.current)
        
        // Set seconds field
        let calendar = Calendar.current
        self.seconds = String(calendar.component(.second, from: self.date))
    }
    
    func ConvertHumanDateToUnixTime() {
        var calendar = Calendar.current
        let components = GetComponentsFromDate(dateParam: self.date, secondsParam: self.seconds)
        calendar.timeZone = TimeZone(identifier: self.timeZoneSelection) ?? TimeZone.current
        self.date = calendar.date(from: components) ?? Date()
        unixTimeText = GetUnixTimeString(dateParam: self.date)
    }
    
    func GetComponentsFromDate(dateParam: Date, secondsParam: String? = "0") -> DateComponents
    {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: self.timeZoneSelection) ?? TimeZone.current
        var components = DateComponents()
        components.day = calendar.component(.day, from: dateParam)
        components.month = calendar.component(.month, from: dateParam)
        components.year = calendar.component(.year, from: dateParam)
        components.hour = calendar.component(.hour, from: dateParam)
        components.minute = calendar.component(.minute, from: dateParam)
        components.second = Int(secondsParam ?? "0")
        return components
    }
    
    func UpdateSecondsFromDate()
    {
        let calendar = Calendar.current
        self.seconds = String(calendar.component(.second, from: self.date))
    }
    
    func GetUnixTimeString(dateParam: Date? = nil) -> String {
        var date = dateParam ?? Date()
        // Adjust date to our local time zone. We will always deal with unix time in our local time zone for simplicity.
        date = date.convert(from: TimeZone(identifier: self.timeZoneSelection) ?? TimeZone.current, to: TimeZone.current)
        
        return String(format: "%.0f", date.timeIntervalSince1970.rounded())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func GetCurrentUnixTimeString(dateParam: Date? = nil) -> String {
    let date = dateParam ?? Date()
    return String(format: "%.0f", date.timeIntervalSince1970.rounded())
}

extension Date {
    func convert(from initTimeZone: TimeZone, to targetTimeZone: TimeZone) -> Date {
        let delta = TimeInterval(targetTimeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
