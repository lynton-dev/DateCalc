//
//  TimeZoneView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-04.
//

import SwiftUI

struct TimeZoneView: View {
    @ObservedObject var dateObservableObject: DateObservableObject
    private let timeZoneIdentifiers = GetCustomKnownTimeZoneIdentifiers()
    
    var body: some View {
        HStack {
            // Select Time Zone
            Picker("Time Zone:", selection: $dateObservableObject.timeZoneSelection) {
                ForEach(self.timeZoneIdentifiers, id: \.self) {
                    Text($0)
                }
            }.frame(maxWidth: 350)
            // Note, the optional square bracket part here was added to set a "pTimeZoneSelection" capture to the previous time zone value
            .onChange(of: self.dateObservableObject.timeZoneSelection) { [pTimeZoneSelection = self.dateObservableObject.timeZoneSelection] newValue in
                // Store the previous time zone selection using the "pTimeZoneSelection" capture
                self.dateObservableObject.previousTimeZoneSelection = pTimeZoneSelection
                
                // Adjust date from previously selected time zone to the newly selected time zone
                let curTimeZone = GetTimeZoneFromCustomIdentifier(customIdentifier: self.dateObservableObject.timeZoneSelection)
                let prevTimeZone = GetTimeZoneFromCustomIdentifier(customIdentifier: self.dateObservableObject.previousTimeZoneSelection)
                self.dateObservableObject.date = self.dateObservableObject.date.convert(from: prevTimeZone, to: curTimeZone)
            }
            
            // Reset time zone button
            ResetButton(help: "Reset to local time zone") {
                ResetTimeZone()
            }
            .padding(.leading, 5)
        }
    }
    
    func ResetTimeZone() {
        self.dateObservableObject.timeZoneSelection = GetCustomTimeZoneIdentifier()
    }
}

struct TimeZoneView_Previews: PreviewProvider {
    static var previews: some View {
        TimeZoneView(dateObservableObject: DateObservableObject())
    }
}


/// Get the known time zone identifiters in a customized format
/// - Returns: A list of custom time zone identifiers represented as an array of Strings
func GetCustomKnownTimeZoneIdentifiers() -> [String] {
    var customKnownTimeZoneIdentifiers: [String] = [""]
    
    for identifier in TimeZone.knownTimeZoneIdentifiers {
        let customIdentifier = identifier + " (" + GetTimeZoneOffsetString(timeZone: TimeZone(identifier: identifier)!) + ")"
        customKnownTimeZoneIdentifiers.append(customIdentifier)
    }
    
    return customKnownTimeZoneIdentifiers
}

/// Get the custom time zone identifier given a built-in time zone identifier
/// - Parameter timeZoneIdentifier: Built-in time zone identifier
/// - Returns: Custom formatted time zone identifer
func GetCustomTimeZoneIdentifier(timeZoneIdentifier: String? = TimeZone.current.identifier) -> String {
    let customIdentifier = (timeZoneIdentifier ?? TimeZone.current.identifier) + " (" + GetTimeZoneOffsetString(timeZone: TimeZone(identifier: timeZoneIdentifier ?? TimeZone.current.identifier)!) + ")"
    return customIdentifier
}


/// Get a TimeZone object representing the time zone held in the given custom time zone identifier
/// - Parameter customIdentifier: Custom time zone identifier
/// - Returns: TimeZone object
func GetTimeZoneFromCustomIdentifier(customIdentifier: String? = TimeZone.current.identifier) -> TimeZone
{
    let timeZone = TimeZone(identifier: customIdentifier?.components(separatedBy: " (")[0] ?? TimeZone.current.identifier) ?? TimeZone.current
    return timeZone
}


/// Get a custom formatted time zone offset string (where the offset is the GMT time zone offset)
/// - Parameter timeZone: TimeZone object
/// - Returns: Custom time zone offset string
func GetTimeZoneOffsetString(timeZone: TimeZone) -> String {
    // Calculate time zone offset
    let outputDateTZ = timeZone
    let seconds = outputDateTZ.secondsFromGMT()
    let hours = seconds / 3600
    let minutes = abs(seconds / 60) % 60
    let tzOffset = String(format: "%+.2d:%.2d", hours, minutes)
    
    // Handle situation where time zone abbreviation is something like GMT-4.
    // We only need "GMT" from this string since we already have the offset.
    var tzAbbr = timeZone.abbreviation()
    if (tzAbbr!.starts(with: "GMT")) {
        tzAbbr = "GMT"
    }
    
    return tzAbbr! + tzOffset
}
