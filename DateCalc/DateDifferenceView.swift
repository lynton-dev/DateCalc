//
//  DateDifferenceView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-19.
//

import SwiftUI

struct DateDifferenceView: View {
    @Environment(\.colorScheme) var colorScheme
    private let minColumnWidth = 375.0
    
    @StateObject private var inputDate1 = DateObservableObject()
    @StateObject private var inputDate2 = DateObservableObject()
    @State private var dateDifference = Text("")
    @State private var dateDifferenceDays = Text("")
    @State private var showDateDifference = false
    
    var body: some View {
        ZStack(alignment: .center) {
            
            HStack {
                Divider()
            }.padding()
            
            VStack {
                
                Button(action: {
                    CalculateDateDifference()
                }) {
                    Image(systemName: "arrow.right.square.fill")
                        .symbolRenderingMode(.multicolor)
                        .resizable()
                        .frame(width: 35, height: 35)

                }
                .background(Color(NSColor.windowBackgroundColor))
                .foregroundColor(colorScheme == .dark ? Color("DarkButtonBackground") : .accentColor)
                .buttonStyle(.plain)
                .help("Calculate date difference")
                
            }
            
            HStack {
                
                // Column 1
                VStack {
                    
                    HStack {
                        
                        VStack(alignment: .leading) {
                            
                            Text("First date:")
                                .padding(.leading, 10)
                        
                            DateView(dateObservableObject: self.inputDate1)
                            
                        }
                        
                        VStack(alignment: .leading) {
                    
                            Text("Second date:")
                                .padding(.leading, 10)
                            
                            DateView(dateObservableObject: self.inputDate2)
                            
                        }
                        
                    }
                }
                .frame(minWidth: self.minColumnWidth)
                .padding(EdgeInsets(top: 20, leading: 70, bottom: 20, trailing: 50))
                
                // Column 2
                VStack {
                        
                    HStack {
                        
                        self.dateDifferenceDays
                            .textSelection(.enabled)
                            .font(.title)
                            .padding(.bottom, 10)
                            
                        Spacer()
                            
                        Text("or")
                            .font(.title)
                            .foregroundColor(.gray)
                            .opacity(self.showDateDifference ? 1 : 0)
                            .padding(.bottom, 10)
                            
                        Spacer()
                            
                        self.dateDifference
                            .textSelection(.enabled)
                            .font(.title)
                            .multilineTextAlignment(.trailing)
                            .lineSpacing(10)
                            .opacity(self.showDateDifference ? 1 : 0)
                        
                    }
                    
                }
                .frame(minWidth: self.minColumnWidth)
                .padding(EdgeInsets(top: 0, leading: 70, bottom: 0, trailing: 50))
            
            }
        }
    }
    
    func CalculateDateDifference() {
        // Which date is newer?
        var date1 = self.inputDate1.date
        var date2 = self.inputDate2.date
        let unixDateTime1 = date1.timeIntervalSince1970.rounded()
        let unixDateTime2 = date2.timeIntervalSince1970.rounded()
        
        // If the first date is newer than the second date, then switch them.
        // Going forward, we want the first date to be the older date
        if (unixDateTime1 > unixDateTime2) {
            let tempDate1 = date1
            date1 = date2
            date2 = tempDate1
        }
        
        // Get the difference as a TimeInterval
        let differenceInterval = date2.timeIntervalSince(date1)
        
        if (!differenceInterval.isInfinite && !differenceInterval.isNaN) {
            // Get the total number of days
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.zeroFormattingBehavior = .dropAll
            formatter.allowedUnits = [.day]
            let daysTotal = formatter.string(from: differenceInterval) ?? ""
            
            if (!daysTotal.isEmpty) {
                // Extract the number of days value and the units (i.e. "day" or "days")
                let daysTotalValue = daysTotal.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                let daysTotalUnits = daysTotal.components(separatedBy: CharacterSet.decimalDigits).joined().trimmingCharacters(in: .whitespaces)
                // Colorize the units text
                let daysTotalText = Text(daysTotalValue + " ").bold() + Text(daysTotalUnits).foregroundColor(.pink)
                // Update the dateDifferentDays text
                self.dateDifferenceDays = daysTotalText
            }
            
            // Next, do the days, months, years components
            formatter.allowedUnits = [.day, .month, .year]
            let dateDifferenceFormatted = formatter.string(from: differenceInterval) ?? ""
            let dateDifferenceComponents = dateDifferenceFormatted.components(separatedBy: ", ")
            var days = ""
            var months = ""
            var years = ""
            for dateComponent in dateDifferenceComponents {
                if (dateComponent.contains("day")) {
                    days = dateComponent
                } else if (dateComponent.contains("month")) {
                    months = dateComponent
                } else if (dateComponent.contains("year")) {
                    years = dateComponent
                }
            }
            
            // Extract the values and units and colorize
            var fullText = Text("")
            
            if (!years.isEmpty) {
                let yearsValue = years.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                let yearsUnits = years.components(separatedBy: CharacterSet.decimalDigits).joined().trimmingCharacters(in: .whitespaces)
                let yearsText = Text(yearsValue + " ").bold() + Text(yearsUnits).foregroundColor(.cyan)
                fullText = yearsText
            }
            
            if (!months.isEmpty) {
                if (!years.isEmpty) {
                    fullText = fullText + Text("\n")
                }
                let monthsValue = months.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                let monthsUnits = months.components(separatedBy: CharacterSet.decimalDigits).joined().trimmingCharacters(in: .whitespaces)
                let monthsText = Text(monthsValue + " ").bold() + Text(monthsUnits).foregroundColor(.orange)
                fullText = fullText + monthsText
            }
            
            if (!days.isEmpty) {
                if (!years.isEmpty || !months.isEmpty) {
                    fullText = fullText + Text("\n")
                }
                let daysValue = days.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                let daysUnits = days.components(separatedBy: CharacterSet.decimalDigits).joined().trimmingCharacters(in: .whitespaces)
                let daysText = Text(daysValue + " ").bold() + Text(daysUnits).foregroundColor(.pink)
                fullText = fullText + daysText
            }
            
            
            // Update the dateDifference text
            self.dateDifference = fullText

            // If there are months or years present, it means we should show the date difference as components
            // in addition to the total number of days.
            if (!months.isEmpty || !years.isEmpty) {
                self.showDateDifference = true
            } else {
                self.showDateDifference = false
            }
        }
    }
    
}

struct DateDifferenceView_Previews: PreviewProvider {
    static var previews: some View {
        DateDifferenceView()
    }
}
