//
//  RestartButton.swift
//  GridPopGame
//
//  Created by EMILY on 12/06/2025.
//

import SpriteKit

class RestartButton: SKSpriteNode {
    
    var touchAction: (() -> Void)?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        let texture = SKTexture(imageNamed: "restart")
        super.init(texture: texture, color: .black, size: .zero)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setScale(1.3)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setScale(1.0)
        
        touchAction?()
    }
}
