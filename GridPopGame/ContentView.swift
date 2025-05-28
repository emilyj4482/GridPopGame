//
//  ContentView.swift
//  GridPopGame
//
//  Created by EMILY on 27/05/2025.
//

import SwiftUI
import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        // create background sprite
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1   // behind other elements
        background.size = size      // scale to scene size
        
        addChild(background)
    }
}

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
