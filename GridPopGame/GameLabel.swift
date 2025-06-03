//
//  GameLabel.swift
//  GridPopGame
//
//  Created by EMILY on 03/06/2025.
//

import SpriteKit

class GameLabel: SKNode {
    
    private let labelNode = SKLabelNode()
    
    init(_ labelCase: LabelCase) {
        super.init()
        labelNode.fontColor = .white
        labelNode.fontName = "HelveticaNeue-Bold"
        labelNode.fontSize = 27
        labelNode.zPosition = 1
        
        switch labelCase {
        case .score:
            labelNode.horizontalAlignmentMode = .left
        case .moves:
            labelNode.horizontalAlignmentMode = .right
        }
        
        addChild(labelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var text: String? {
        get { labelNode.text }
        set { labelNode.text = newValue }
    }
    
    var labelWidth: CGFloat {
        return labelNode.bounds.width
    }
}

enum LabelCase {
    case score
    case moves
}
