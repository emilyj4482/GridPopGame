//
//  Background.swift
//  GridPopGame
//
//  Created by EMILY on 31/05/2025.
//

import SpriteKit

class Background: SKSpriteNode {
    init(imageNamed: String, size: CGSize) {
        super.init(texture: SKTexture(imageNamed: imageNamed), color: .clear, size: size)
        position = CGPoint(x: size.width / 2, y: size.height / 2)
        zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
