//
//  ContentView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-02.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // Unix epoch time converter
    @ObservedObject private var unixTime = UnixTime(unixTimeText: GetUnixTimeString())
    @ObservedObject private var humanDate = DateObservableObject()
    
    // Time Zone converter
    @ObservedObject private var inputDate = DateObservableObject()
    @ObservedObject private var outputDate = DateObservableObject()
    @State private var convertedDate = ""
    @State private var convertedDateTZAbbr = ""
    @State private var showingTZAbbrPopover = false
    
    @State private var tabSelection = UserDefaults.standard.integer(forKey: "tabSelection")
    private let minColumnWidth = 375.0
    
    var body: some View {
        
        TabView(selection: $tabSelection) {
            
            // Tab 1 - Unix epoch time converter
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
                    .frame(minWidth: minColumnWidth)
                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 75))
                    
                    // Column 2
                    VStack {
                        
                        DateTimeZoneView(dateObservableObject: self.humanDate)
                        .onAppear() {
                            // Make sure the unix time and this date match up on launch
                            ConvertUnixTimeToHumanDate()
                        }
                        
                    }
                    .frame(minWidth: minColumnWidth)
                    .padding(EdgeInsets(top: 0, leading: 75, bottom: 0, trailing: 25))
                    
                }
                
            }
            .tabItem {
                Text("Unix Epoch Time Converter")
            }
            .tag(1)
            
            // Tab 2 - Time Zone converter
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
                        
                        DateTimeZoneView(dateObservableObject: self.inputDate)
                        
                    }
                    .frame(minWidth: minColumnWidth)
                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 75))
                    
                    // Column 2
                    VStack {
                        TimeZoneView(dateObservableObject: self.outputDate)
                            .onChange(of: self.outputDate.timeZoneSelection) { newValue in
                                // When this time zone is changed then convert the time zone
                                ConvertTimeZone()
                        }
                        
                        HStack(alignment: .top) {
                            
                            Text(self.convertedDate)
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
                                Text(GetTimeZoneOffsetString(timeZone: GetTimeZoneFromCustomIdentifier(customIdentifier: self.outputDate.timeZoneSelection)))
                                    .padding()
                            }
                            .buttonStyle(.plain)
                            .background(.clear)
                            .foregroundColor(.gray)
                            .opacity(self.convertedDate == "" ? 0 : 1)
                            
                        }
                        .padding(.top, 20)
                        
                    }
                    .frame(minWidth: minColumnWidth)
                    .padding(EdgeInsets(top: 0, leading: 75, bottom: 0, trailing: 25))
                    
                }
            }
            .tabItem {
                Text("Time Zone Converter")
            }
            .tag(2)
            
            // Tab 3 - Date Calculator
            ZStack(alignment: .center) {
                
            }
            .tabItem {
                Text("Date Calculator")
            }
            .tag(3)
            
        }
        .onChange(of: self.tabSelection, perform: { index in
            UserDefaults.standard.set(self.tabSelection, forKey: "tabSelection")
        })
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
    
    
    /// Convert the input date with a set time zone to an output date of another time zone
    func ConvertTimeZone() {
        let inputDateTZ = GetTimeZoneFromCustomIdentifier(customIdentifier: self.inputDate.timeZoneSelection)
        let outputDateTZ = GetTimeZoneFromCustomIdentifier(customIdentifier: self.outputDate.timeZoneSelection)
        
        self.outputDate.date = self.inputDate.date.convert(from: inputDateTZ, to: outputDateTZ)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        self.convertedDate = formatter.string(from: self.outputDate.date)
        
        self.convertedDateTZAbbr = outputDateTZ.abbreviation()!
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


/// Get components of a given date
/// - Parameters:
///   - dateParam: date
///   - secondsParam: seconds
///   - timeZone: time zone
/// - Returns: DateComponents object composed of the given parameters
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
