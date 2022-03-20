//
//  ResetTextButton.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-20.
//

import SwiftUI

/// Custom button view for reset type buttons
struct ResetTextButton: View {
    let text: String?
    let help: String?
    let action: () -> Void

    init(text: String? = "", help: String? = "", action: @escaping () -> Void) {
        self.text = text
        self.help = help
        self.action = action
    }

    var body: some View {
        Button(action: action,
               label: { Label(text ?? "", systemImage: "clock.arrow.circlepath") })
            .help(help ?? "")
    }
}

struct ResetTextButton_Previews: PreviewProvider {
    static var previews: some View {
        ResetButton(action: {})
    }
}
