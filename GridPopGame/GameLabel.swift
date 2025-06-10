//
//  GameLabel.swift
//  GridPopGame
//
//  Created by EMILY on 03/06/2025.
//

import SpriteKit

class GameLabel: SKLabelNode {
    init(type: LabelType) {
        super.init()
        fontColor = .white
        fontName = "HelveticaNeue-Bold"
        fontSize = 27
        zPosition = 1
        horizontalAlignmentMode = type.horizontalAlignmentMode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum LabelType {
    case score
    case moves
    
    var horizontalAlignmentMode: SKLabelHorizontalAlignmentMode {
        switch self {
        case .score:
            return .left
        case .moves:
            return .right
        }
    }
}
