//
//  TimeZoneConverterView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-18.
//

import SwiftUI

struct TimeZoneConverterView: View {
    @Environment(\.colorScheme) var colorScheme
    private let minColumnWidth = 375.0

    @ObservedObject private var tzInputDate = DateObservableObject()
    @ObservedObject private var tzOutputDate = DateObservableObject()
    @State private var tzConvertedDate = ""
    @State private var convertedDateTZAbbr = ""
    @State private var showingTZAbbrPopover = false
    
    var body: some View {
        ZStack(alignment: .center) {
            
            HStack {
                Divider()
            }.padding()
            
            VStack {
                
                Button(action: {
                    ConvertTimeZone()
                }) {
                    Image(systemName: "arrow.right.square.fill")
                        .resizable()
                        .frame(width: 35, height: 35)

                }
                .background(Color(NSColor.windowBackgroundColor))
                .foregroundColor(colorScheme == .dark ? Color("DarkButtonBackground") : .accentColor)
                .buttonStyle(.plain)
                .help("Convert to human readable date")
                
            }
            
            HStack {
                
                // Column 1
                VStack {
                    
                    DateTimeZoneView(dateObservableObject: self.tzInputDate)
                    
                }
                .frame(minWidth: self.minColumnWidth)
                .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 75))
                
                // Column 2
                VStack {
                    TimeZoneView(dateObservableObject: self.tzOutputDate)
                        .onChange(of: self.tzOutputDate.timeZoneSelection) { newValue in
                            // When this time zone is changed then convert the time zone
                            ConvertTimeZone()
                    }
                    
                    HStack(alignment: .top) {
                        
                        Text(self.tzConvertedDate)
                            .textSelection(.enabled)
                            .font(.title2)
                        
                        Text(self.convertedDateTZAbbr)
                            .font(.title2)
                        
                        Button(action: {
                            self.showingTZAbbrPopover.toggle()
                        }) {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .frame(width: 10, height: 10)
                        }
                        .popover(isPresented: $showingTZAbbrPopover) {
                            Text(GetTimeZoneOffsetString(timeZone: GetTimeZoneFromCustomIdentifier(customIdentifier: self.tzOutputDate.timeZoneSelection)))
                                .padding()
                        }
                        .buttonStyle(.plain)
                        .background(.clear)
                        .foregroundColor(.gray)
                        .opacity(self.tzConvertedDate == "" ? 0 : 1)
                        
                    }
                    .padding(.top, 20)
                    
                }
                .frame(minWidth: self.minColumnWidth)
                .padding(EdgeInsets(top: 0, leading: 75, bottom: 0, trailing: 25))
                
            }
        }
    }
    
    /// Convert the input date with a set time zone to an output date of another time zone
    func ConvertTimeZone() {
        let inputDateTZ = GetTimeZoneFromCustomIdentifier(customIdentifier: self.tzInputDate.timeZoneSelection)
        let outputDateTZ = GetTimeZoneFromCustomIdentifier(customIdentifier: self.tzOutputDate.timeZoneSelection)
        
        self.tzOutputDate.date = self.tzInputDate.date.convert(from: inputDateTZ, to: outputDateTZ)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        self.tzConvertedDate = formatter.string(from: self.tzOutputDate.date)
        
        self.convertedDateTZAbbr = outputDateTZ.abbreviation()!
    }
    
}

struct TimeZoneConverterView_Previews: PreviewProvider {
    static var previews: some View {
        TimeZoneConverterView()
    }
}
