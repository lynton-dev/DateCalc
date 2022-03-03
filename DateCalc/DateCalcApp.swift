//
//  DateCalcApp.swift
//  DateCalc
//
//  Created by Lynton Schoeman on 2022-03-02.
//

import SwiftUI

@main
struct DateCalcApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
         return true
    }
}
