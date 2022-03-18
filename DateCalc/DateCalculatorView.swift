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
    @State private var calcSelectedOperation = "Add"
    @State private var operators = ["Add", "Subtract"]
    @State private var years = "0"
    @State private var months = "0"
    @State private var weeks = "0"
    @State private var days = "0"
    
    var body: some View {
        ZStack(alignment: .center) {
            
            HStack {
                Divider()
            }.padding()
            
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
                                .pickerStyle(.segmented)
                            }
                            .padding(.bottom, 20)
                            
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
                                        .onChange(of: self.years) { newValue in
                                            CalculateDate()
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                    
                                    TextField("", text: $months)
                                        .onChange(of: self.months) { newValue in
                                            CalculateDate()
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                    
                                    TextField("", text: $weeks)
                                        .onChange(of: self.weeks) { newValue in
                                            CalculateDate()
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                    
                                    TextField("", text: $days)
                                        .onChange(of: self.days) { newValue in
                                            CalculateDate()
                                        }
                                        .multilineTextAlignment(.center)
                                        .frame(width: 60)
                                            
                                }
                                
                            }
                            
                        }
                        
                    }
                    .frame(width: 240)
                    
                }
                .frame(minWidth: self.minColumnWidth)
                .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 75))
                
                // Column 2
                VStack {

                    HStack(alignment: .top) {
                        
                        Text(self.calcConvertedDate)
                            .textSelection(.enabled)
                            .font(.title2)
                        
                    }
                    .padding(.top, 20)
                    
                }
                .frame(minWidth: self.minColumnWidth)
                .padding(EdgeInsets(top: 0, leading: 75, bottom: 0, trailing: 25))
            
            }
        }
    }
    
    func CalculateDate()
    {
        let calendar = Calendar.current
        var components = GetComponentsFromDate(dateParam: self.calcInputDate.date)
        
        if (self.calcSelectedOperation == "Add") {
            components.year! += Int(self.years) ?? 0
            components.month! += Int(self.months) ?? 0
            components.day! += (Int(self.weeks) ?? 0) * 7
            components.day! += Int(self.days) ?? 0
        } else if (self.calcSelectedOperation == "Subtract") {
            components.year! -= Int(self.years) ?? 0
            components.month! -= Int(self.months) ?? 0
            components.day! -= (Int(self.weeks) ?? 0) * 7
            components.day! -= Int(self.days) ?? 0
        }
        
        let outputDate = calendar.date(from: components) ?? Date()
                
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        self.calcConvertedDate = formatter.string(from: outputDate)
    }
    
}

struct DateCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        DateCalculatorView()
    }
}
