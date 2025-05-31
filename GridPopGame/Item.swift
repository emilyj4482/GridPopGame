//
//  Item.swift
//  GridPopGame
//
//  Created by EMILY on 28/05/2025.
//

import SpriteKit

class Item: SKSpriteNode {
    var column: Int
    var row: Int
    
    init(imageNamed: String, column: Int, row: Int) {
        self.column = column
        self.row = row
        super.init(texture: SKTexture(imageNamed: imageNamed), color: .clear, size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
