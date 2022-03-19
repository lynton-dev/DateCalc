//
//  DateCalculatorView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-18.
//

import SwiftUI

struct DateCalculatorView: View {
    @Environment(\.colorScheme) var colorScheme
    private let minColumnWidth = 375.0
    
    @ObservedObject private var calcInputDate = DateObservableObject()
    @State private var calcConvertedDate = ""
    @State private var calcConvertedDateLong = ""
    @State private var calcSelectedOperation = "Add"
    @State private var operators = ["Add", "Subtract"]
    @State private var years = "0"
    @State private var months = "0"
    @State private var weeks = "0"
    @State private var days = "0"
    @State private var hours = "0"
    @State private var minutes = "0"
    @State private var seconds = "0"
    
    var body: some View {
        ZStack(alignment: .center) {
            
            HStack {
                Divider()
            }.padding()
            
            VStack {
                
                Button(action: {
                    CalculateDate()
                }) {
                    Image(systemName: "arrow.right.square.fill")
                        .resizable()
                        .frame(width: 35, height: 35)

                }
                .background(Color(NSColor.windowBackgroundColor))
                .foregroundColor(colorScheme == .dark ? Color("DarkButtonBackground") : .accentColor)
                .buttonStyle(.plain)
                .help("Calculate date")
                
            }
            
            HStack {
                
                // Column 1
                VStack {
                    
                    DateView(dateObservableObject: self.calcInputDate)
                        .padding(.bottom, 20)
                    
                    Form {
                        VStack {
                            
                            Section() {
                                
                                Picker("", selection: $calcSelectedOperation) {
                                    ForEach(operators, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .onChange(of: self.calcSelectedOperation)  { _ in
                                    CalculateDate()
                                }
                                .pickerStyle(.segmented)
                                
                            }
                            .padding(.bottom, 10)
                            
                            HStack() {
                                
                                Text("Years")
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60)
                                
                                Text("Months")
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60)
                                
                                Text("Weeks")
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60)
                                
                                Text("Days")
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60)
                            }
                            
                            HStack {
                                
                                Section() {
                                    
                                    TextField("", text: $years)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                    
                                    TextField("", text: $months)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                    
                                    TextField("", text: $weeks)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                    
                                    TextField("", text: $days)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                        
                                }
                                
                            }
                            .padding(.bottom, 5)
                            
                            HStack() {
                                
                                Text("Hours")
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60)
                                
                                Text("Minutes")
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60)
                                
                                Text("Seconds")
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60)
                                
                            }
                            
                            HStack {
                                
                                Section() {
                                    
                                    TextField("", text: $hours)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                    
                                    TextField("", text: $minutes)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                    
                                    TextField("", text: $seconds)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                        
                                }
                                
                            }
                            .padding(.bottom, 10)
                            
                            HStack {
                                
                                Button {
                                    self.years = "0"
                                    self.months = "0"
                                    self.weeks = "0"
                                    self.days = "0"
                                    self.hours = "0"
                                    self.minutes = "0"
                                    self.seconds = "0"
                                } label: {
                                    Label("Clear", systemImage: "arrow.counterclockwise")
                                }
                                .help("Clear")
                                
                            }
                            
                        }
                        
                    }
                    .frame(width: 240)
                    
                }
                .frame(minWidth: self.minColumnWidth)
                .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 75))
                
                // Column 2
                VStack {

                    HStack {
                        
                        Text(self.calcConvertedDate)
                            .textSelection(.enabled)
                            .font(.title)
                        
                    }
                    .padding(.bottom, 2)
                    
                    HStack {
                        
                        Text(self.calcConvertedDateLong)
                            .textSelection(.enabled)
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                    }
                    
                }
                .frame(minWidth: self.minColumnWidth)
                .padding(EdgeInsets(top: 0, leading: 75, bottom: 0, trailing: 50))
            
            }
        }
    }
    
    func CalculateDate()
    {
        let calendar = Calendar.current
        var components = GetComponentsFromDate(dateParam: self.calcInputDate.date)
        components.second = Int(self.calcInputDate.seconds)
        
        if (self.calcSelectedOperation == "Add") {
            components.year! += Int(self.years) ?? 0
            components.month! += Int(self.months) ?? 0
            components.day! += (Int(self.weeks) ?? 0) * 7
            components.day! += Int(self.days) ?? 0
            components.hour! += Int(self.hours) ?? 0
            components.minute! += Int(self.minutes) ?? 0
            components.second! += Int(self.seconds) ?? 0
        } else if (self.calcSelectedOperation == "Subtract") {
            components.year! -= Int(self.years) ?? 0
            components.month! -= Int(self.months) ?? 0
            components.day! -= (Int(self.weeks) ?? 0) * 7
            components.day! -= Int(self.days) ?? 0
            components.hour! -= Int(self.hours) ?? 0
            components.minute! -= Int(self.minutes) ?? 0
            components.second! -= Int(self.seconds) ?? 0
        }
        
        let outputDate = calendar.date(from: components) ?? Date()
                
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        self.calcConvertedDate = formatter.string(from: outputDate)
        
        formatter.dateFormat = "EEEE, dd MMMM, yyyy"
        self.calcConvertedDateLong = formatter.string(from: outputDate)
    }
    
}

struct DateCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        DateCalculatorView()
    }
}
