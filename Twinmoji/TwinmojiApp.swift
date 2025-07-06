//
//  TwinmojiApp.swift
//  Twinmoji
//
//  Created by David Chea on 29/06/2025.
//

import SwiftUI

@main
struct TwinmojiApp: App {
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            MenuView().preferredColorScheme(.light)
        }
    }
}
