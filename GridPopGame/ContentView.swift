//
//  ContentView.swift
//  GridPopGame
//
//  Created by EMILY on 27/05/2025.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    var scene: SKScene = GameScene()
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
