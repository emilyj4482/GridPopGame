//
//  ContentView.swift
//  GridPopGame
//
//  Created by EMILY on 27/05/2025.
//

import SwiftUI
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var columns: [[Item]] = []
    var itemSize: CGFloat = 50
    var itemsPerColumn: Int = 7
    var itemsPerRow: Int = 7
    
    override func didMove(to view: SKView) {
        // set scene size explicitly
        self.size = view.bounds.size
        
        // create background sprite
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1   // behind other elements
        background.size = size      // scale to scene size
        
        addChild(background)
        
        for x in 0..<itemsPerRow {
            var column = [Item]()
            
            for y in 0..<itemsPerColumn {
                let item = createItem(column: x, row: y)
                column.append(item)
            }
            
            columns.append(column)
        }
    }
    
    func positionItem(for item: Item) -> CGPoint {
        let xOffset: CGFloat = 50
        let yOffset: CGFloat = 300
        
        let x = xOffset + itemSize * CGFloat(item.column)
        let y = yOffset + itemSize * CGFloat(item.row)
        
        return CGPoint(x: x, y: y)
    }
    
    func createItem(column: Int, row: Int, startOffScreen: Bool = false) -> Item {
        let itemImages = [
            "cheese",
            "mackerel",
            "gray",
            "vanila",
            "calico"
        ]
        
        let itemImage = itemImages[GKRandomSource.sharedRandom().nextInt(upperBound: itemImages.count)]
        
        let item = Item(imageNamed: itemImage)
        
        item.name = itemImage
        item.column = column
        item.row = row
        item.position = positionItem(for: item)
        item.size = CGSize(width: itemSize, height: itemSize)
        addChild(item)
        
        return item
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
