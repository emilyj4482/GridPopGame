//
//  GameLabel.swift
//  GridPopGame
//
//  Created by EMILY on 03/06/2025.
//

import SpriteKit

class GameLabel: SKLabelNode {
    override init() {
        super.init()
        fontColor = .white
        fontName = "HelveticaNeue-Bold"
        fontSize = 27
        zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
