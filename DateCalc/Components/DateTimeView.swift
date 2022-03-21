//
//  DateTimeView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-04.
//

import SwiftUI

struct DateTimeView: View {
    @StateObject var dateObservableObject: DateObservableObject
    
    var body: some View {
        HStack {
            
            DatePicker(
                "Date:",
                selection: $dateObservableObject.date,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.field)
            .frame(width: 195)
            
            // Seconds text field
            TextField("", text: $dateObservableObject.seconds)
                .onChange(of: self.dateObservableObject.seconds) { newValue in
                // Seconds field validation
                    if (self.dateObservableObject.seconds.isEmpty || !self.dateObservableObject.seconds.isNumber) {
                        self.dateObservableObject.seconds = "0"
                        return
                }
                
                let secondsInt = Int(self.dateObservableObject.seconds) ?? 0
                if (secondsInt < 0 || secondsInt >= 60) {
                    self.dateObservableObject.seconds = self.dateObservableObject.previousSeconds
                } else {
                    self.dateObservableObject.previousSeconds = self.dateObservableObject.seconds
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
            ResetButton(help: "Reset to current time") {
                ResetDate()
            }
            .padding(.leading, 5)
            
        }
    }
    
    /// Reset the date and seconds fields to the current datetime.
    func ResetDate() {
        // Get current Date
        var newDate = Date()
        
        // Ensure to convert to currently selected time zone if not the local time zone
        if (self.dateObservableObject.timeZoneSelection != TimeZone.current.identifier)
        {
            newDate = newDate.convert(from: TimeZone.current, to: GetTimeZoneFromCustomIdentifier(customIdentifier: self.dateObservableObject.timeZoneSelection))
        }
        
        // Update the date and seconds fields with the new datetime
        self.dateObservableObject.date = newDate
        UpdateSecondsFromDate()
    }
    
    func UpdateSecondsFromDate()
    {
        let calendar = Calendar.current
        self.dateObservableObject.seconds = String(calendar.component(.second, from: self.dateObservableObject.date))
    }
}

struct DateTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimeView(dateObservableObject: DateObservableObject())
    }
}
