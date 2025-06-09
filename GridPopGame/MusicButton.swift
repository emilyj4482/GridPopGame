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
    
    init() {
        let texture = SKTexture(imageNamed: ImageName.musicOn.rawValue)
        let size = CGSize(width: 30, height: 30)
        super.init(texture: texture, color: .white, size: size)
        isUserInteractionEnabled = true
        colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func toggleImage() {
        let imageName = isMusicOn ? ImageName.musicOn.rawValue : ImageName.musicOff.rawValue
        
        texture = SKTexture(imageNamed: imageName)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setScale(0.9)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMusicOn.toggle()
        
        setScale(1.0)
    }
}

enum ImageName: String {
    case musicOn
    case musicOff
}
