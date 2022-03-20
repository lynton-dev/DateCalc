//
//  HumanDateView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-04.
//

import SwiftUI

struct DateTimeZoneView: View {
    @ObservedObject var dateObservableObject: DateObservableObject
    
    var body: some View {
        VStack {
            DateTimeView(dateObservableObject: dateObservableObject)
            .padding(.bottom, 10)
            
            TimeZoneView(dateObservableObject: dateObservableObject)
        }
    }
}

struct DateTimeZoneView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimeZoneView(dateObservableObject: DateObservableObject())
    }
}

class DateObservableObject: ObservableObject {
    @Published var date = Date()
    @Published var seconds = "0"
    @Published var previousSeconds = "0"
    @Published var timeZoneSelection = GetCustomTimeZoneIdentifier()
    @Published var previousTimeZoneSelection = GetCustomTimeZoneIdentifier()
    
    init() {}
}

extension Date {
    func convert(from initTimeZone: TimeZone, to targetTimeZone: TimeZone) -> Date {
        let delta = TimeInterval(targetTimeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }
}
