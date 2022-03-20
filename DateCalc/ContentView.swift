//
//  ContentView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-02.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = UserDefaults.standard.integer(forKey: "tabSelection")
    
    var body: some View {
        
        TabView(selection: $tabSelection) {
            
            // Tab 1 - Unix epoch time converter
            UnixTimeConverterView()
            .tabItem {
                Text("Unix Epoch Time Converter")
            }
            .tag(1)
            
            // Tab 2 - Time Zone converter
            TimeZoneConverterView()
            .tabItem {
                Text("Time Zone Converter")
            }
            .tag(2)
            
            // Tab 3 - Date Calculator
            DateCalculatorView()
            .tabItem {
                Text("Date Calculator")
            }
            .tag(3)
            
            // Tab 4 - Date Difference
            DateDifferenceView()
            .tabItem {
                Text("Date Difference")
            }
            .tag(4)
            
        }
        .onChange(of: self.tabSelection, perform: { index in
            UserDefaults.standard.set(self.tabSelection, forKey: "tabSelection")
        })
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
    
    if (secondsParam == nil)
    {
        components.second = calendar.component(.second, from: dateParam)
    } else {
        components.second = Int(secondsParam ?? "0")
    }
    
    return components
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
