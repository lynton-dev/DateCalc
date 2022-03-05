//
//  TimeZoneView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-04.
//

import SwiftUI

struct TimeZoneView: View {
    @ObservedObject var dateObservableObject: DateObservableObject
    private let timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
    
    var body: some View {
        HStack {
            // Select Time Zone
            Picker("Time Zone:", selection: $dateObservableObject.timeZoneSelection) {
                ForEach(self.timeZoneIdentifiers, id: \.self) {
                    Text($0)
                }
            }   // Note, the optional square bracket part here was added to set a "pTimeZoneSelection" capture to the previous time zone value
            .onChange(of: self.dateObservableObject.timeZoneSelection) { [pTimeZoneSelection = self.dateObservableObject.timeZoneSelection] newValue in
                // Store the previous time zone selection using the "pTimeZoneSelection" capture
                self.dateObservableObject.previousTimeZoneSelection = pTimeZoneSelection
                
                // Adjust date from previously selected time zone to the newly selected time zone
                self.dateObservableObject.date = self.dateObservableObject.date.convert(from: TimeZone(identifier: self.dateObservableObject.previousTimeZoneSelection)!, to: TimeZone(identifier: self.dateObservableObject.timeZoneSelection)!)
            }.onTapGesture {
                print("click")
            }
            
            // Reset time zone button
            ResetButton(help: "Reset to local time zone") {
                ResetTimeZone()
            }
            .padding(.leading, 5)
        }
    }
    
    func ResetTimeZone() {
        self.dateObservableObject.timeZoneSelection = TimeZone.current.identifier
    }
}

struct TimeZoneView_Previews: PreviewProvider {
    static var previews: some View {
        TimeZoneView(dateObservableObject: DateObservableObject())
    }
}
