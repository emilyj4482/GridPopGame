//
//  MusicButton.swift
//  GridPopGame
//
//  Created by EMILY on 09/06/2025.
//

import SpriteKit

class MusicButton: SKSpriteNode {
    private var isMusicOn: Bool = true {
        didSet {
            toggleImage()
        }
    }
    
    var buttonAction: ((Bool) -> Void)?
    
    init() {
        let texture = SKTexture(imageNamed: Assets.musicOn.rawValue)
        let size = CGSize(width: 30, height: 30)
        super.init(texture: texture, color: .white, size: size)
        isUserInteractionEnabled = true
        colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func toggleImage() {
        let imageName = isMusicOn ? Assets.musicOn.rawValue : Assets.musicOff.rawValue
        
        texture = SKTexture(imageNamed: imageName)
        
        alpha = isMusicOn ? 1.0 : 0.8
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setScale(0.9)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setScale(1.0)
        
        isMusicOn.toggle()
        buttonAction?(isMusicOn)
    }
}
