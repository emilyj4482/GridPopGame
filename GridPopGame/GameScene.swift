//
//  GameScene.swift
//  GridPopGame
//
//  Created by EMILY on 31/05/2025.
//

import SwiftUI
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var columns: [[Item]] = []
    
    private let itemsPerColumn: Int = 8
    private let itemsPerRow: Int = 8
    
    private var itemSize: CGFloat {
        // calculate item size dynamically based on screen size
        let horizontalGridSize = size.width / CGFloat(itemsPerRow)
        let verticalGridSize = size.height / CGFloat(itemsPerColumn)
        
        return min(horizontalGridSize, verticalGridSize) * 0.95
    }
    
    private var gridStartX: CGFloat {
        let gridWidth = itemSize * CGFloat(itemsPerRow)
        let spareWidth = size.width - gridWidth
        // the reason adding itemSize / 2 : SpriteKit positions sprites by their center point (anchor point), not their top-left corner.
        return (spareWidth / 2) + (itemSize / 2)
    }
    
    private var gridStartY: CGFloat {
        let gridHeight = itemSize * CGFloat(itemsPerColumn)
        let spareHeight = size.height - gridHeight
        return (spareHeight / 2) + (itemSize / 2)
    }
    
    var currentMatch = Set<Item>()
    
    override func didMove(to view: SKView) {
        // set scene size explicitly
        self.size = view.bounds.size
        
        // create background sprite
        let background = SKSpriteNode(imageNamed: Items.background)
        
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1   // behind other elements
        background.size = size      // scale to scene size
        
        // let background = Background(imageNamed: Items.background, size: size)
        addChild(background)
        
        createGrid()
    }
    
    private func createGrid() {
        for x in 0..<itemsPerRow {
            var column = [Item]()
            
            for y in 0..<itemsPerColumn {
                let item = createItem(column: x, row: y)
                column.append(item)
            }
            
            columns.append(column)
        }
    }
    
    private func positionItem(for item: Item) -> CGPoint {
        let x: CGFloat = gridStartX + (itemSize * CGFloat(item.column))
        let y: CGFloat = gridStartY + (itemSize * CGFloat(item.row))
        
        return CGPoint(x: x, y: y)
    }
    
    func createItem(column: Int, row: Int, startOffScreen: Bool = false) -> Item {
        let itemImages = Items.allCases.map { $0.imageName }
        
        let itemImage = itemImages[GKRandomSource.sharedRandom().nextInt(upperBound: itemImages.count)]
        
        let item = Item(imageNamed: itemImage, column: column, row: row)
        
        item.name = itemImage
        item.position = positionItem(for: item)
        item.size = CGSize(width: itemSize, height: itemSize)
        addChild(item)
        
        return item
    }
}

extension GameScene {
    func findItem(point: CGPoint) -> Item? {
        let item = nodes(at: point).compactMap { $0 as? Item }
        return item.first
    }
    
    func findMatch(currentItem: Item) {
        var checkItems = [Item?]()
        
        currentMatch.insert(currentItem)
        
        let position = currentItem.position
        checkItems.append(findItem(point: CGPoint(x: position.x, y: position.y - itemSize)))
        checkItems.append(findItem(point: CGPoint(x: position.x, y: position.y + itemSize)))
        checkItems.append(findItem(point: CGPoint(x: position.x - itemSize, y: position.y)))
        checkItems.append(findItem(point: CGPoint(x: position.x + itemSize, y: position.y)))
        
        for case let check? in checkItems {
            if currentMatch.contains(check) {
                continue
            }
            
            if check.name == currentItem.name {
                findMatch(currentItem: check)
            }
        }
    }
    
    func removeMatches() {
        for item in currentMatch {
            item.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        guard let tappedItem = findItem(point: location) else { return }
        
        currentMatch.removeAll()
        findMatch(currentItem: tappedItem)
        removeMatches()
    }
}

#Preview {
    ContentView()
}
