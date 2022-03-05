//
//  ResetButton.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-04.
//

import SwiftUI

/// Custom button view for reset type buttons
struct ResetButton: View {
    let help: String?
    let action: () -> Void

    init(help: String? = "", action: @escaping () -> Void) {
        self.help = help
        self.action = action
    }

    var body: some View {
        Button(action: action,
               label: { Image(systemName: "clock.arrow.circlepath") })
            .help(help ?? "")
    }
}

struct ResetButton_Previews: PreviewProvider {
    static var previews: some View {
        ResetButton(action: {})
    }
}
