//
//  DateView.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-19.
//

import SwiftUI

struct DateView: View {
    @StateObject var dateObservableObject: DateObservableObject
    @State private var dateLong = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            
            DatePicker(
                "",
                selection: $dateObservableObject.date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .onAppear() {
                UpdateDateLong()
            }
            .onChange(of: self.dateObservableObject.date, perform: { newValue in
                UpdateDateLong()
            })
            
            Text(self.dateLong)
                .textSelection(.enabled)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            ResetTextButton(text: "Reset", help: "Reset to current date") {
                ResetDate()
            }
            .padding(.leading, 40)
            
        }
    }
    
    func UpdateDateLong() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM, yyyy"
        self.dateLong = formatter.string(from: self.dateObservableObject.date)
    }
    
    /// Reset the date field to the current date.
    func ResetDate() {
        self.dateObservableObject.date = Date()
    }
    
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(dateObservableObject: DateObservableObject())
    }
}
