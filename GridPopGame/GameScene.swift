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
    
    private let backgroundImage = SKSpriteNode(imageNamed: Assets.background.rawValue)
    
    private let backgroundMusic: SKAudioNode = {
        let node = SKAudioNode(fileNamed: Assets.backgroundMusic.rawValue)
        
        node.isPositional = false
        node.autoplayLooped = true
        
        return node
    }()
    
    private let popSound: SKAudioNode = {
        let node = SKAudioNode(fileNamed: Assets.popSound.rawValue)
        
        node.isPositional = false
        node.autoplayLooped = false
        
        return node
    }()
    
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
    
    private let scoreLabel = GameLabel(type: .score)
    
    private var score: Int = 0 {
        didSet {
            scoreLabel.text = "score : \(score)"
        }
    }
    
    private var scoreXOffset: CGFloat {
        let spareWidth = size.width - (itemSize * CGFloat(itemsPerRow))
        return (spareWidth / 2)
    }
    
    private var labelYOffset: CGFloat {
        return size.height - (gridStartY * 0.7)
    }
    
    private let movesLabel = GameLabel(type: .moves)
    
    private var moves: Int = 10 {
        didSet {
            movesLabel.text = "moves : \(moves)"
        }
    }
    
    private var movesXOffset: CGFloat {
        let spareWidth = size.width - (itemSize * CGFloat(itemsPerRow))
        return size.width - spareWidth / 2
    }
    
    private var musicButton = MusicButton()
    
    private let gameoverImage = SKSpriteNode(imageNamed: Assets.gameover.rawValue)
    
    private let restartButton = RestartButton()
    
    override func didMove(to view: SKView) {
        // set scene size explicitly
        self.size = view.bounds.size
        
        addBackgroundImage()
        addAudioNodes()
        
        createGrid()
        
        addLabels()
        
        addMusicButton()
        
        gameoverImage.addChild(restartButton)
    }
    
    private func addBackgroundImage() {
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.zPosition = -1   // behind other elements
        backgroundImage.size = size      // scale to scene size
        
        addChild(backgroundImage)
    }
    
    private func addAudioNodes() {
        addChild(backgroundMusic)
        addChild(popSound)
    }
    
    private func addMusicButton() {
        let x = movesXOffset - musicButton.size.width / 2
        let y = movesLabel.position.y + musicButton.size.height * 2.5
        
        musicButton.position = CGPoint(x: x, y: y)
        
        musicButton.buttonAction = { [weak self] isMusicOn in
            isMusicOn
            ? self?.backgroundMusic.run(SKAction.play())
            : self?.backgroundMusic.run(SKAction.pause())
        }
        
        addChild(musicButton)
    }
    
    private func addLabels() {
        score = 0
        scoreLabel.position = CGPoint(x: scoreXOffset, y: labelYOffset)
        
        moves = 10
        movesLabel.position = CGPoint(x: movesXOffset, y: labelYOffset)
        
        addChild(scoreLabel)
        addChild(movesLabel)
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
        
        if startOffScreen {
            let finalPosition = positionItem(for: item)
            item.position = finalPosition
            item.position.y += (itemSize * CGFloat(itemsPerColumn))
            
            let downAction = SKAction.move(to: finalPosition, duration: 0.4)
            item.run(downAction)
        } else {
            item.position = positionItem(for: item)
        }
        
        
        item.size = CGSize(width: itemSize, height: itemSize)
        addChild(item)
        
        return item
    }
    
    var matchedItems = Set<Item>()
}

extension GameScene {
    func findItem(point: CGPoint) -> Item? {
        let item = nodes(at: point).compactMap { $0 as? Item }
        return item.first
    }
    
    func findMatch(currentItem: Item) {
        var checkItems = [Item?]()
        
        matchedItems.insert(currentItem)
        
        let position = currentItem.position
        checkItems.append(findItem(point: CGPoint(x: position.x, y: position.y - itemSize)))
        checkItems.append(findItem(point: CGPoint(x: position.x, y: position.y + itemSize)))
        checkItems.append(findItem(point: CGPoint(x: position.x - itemSize, y: position.y)))
        checkItems.append(findItem(point: CGPoint(x: position.x + itemSize, y: position.y)))
        
        for case let check? in checkItems {
            if matchedItems.contains(check) {
                continue
            }
            
            if check.name == currentItem.name {
                findMatch(currentItem: check)
            }
        }
    }
    
    func removeMatches() {
        guard matchedItems.count > 1 else { return }
        
        let sortedMatches = matchedItems.sorted {
            $0.row > $1.row
        }
        
        for item in sortedMatches {
            columns[item.column].remove(at: item.row)
            
            item.removeFromParent()
        }
        
        popSound.run(SKAction.play())
        
        moveCountDown()
        scoreUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        guard let tappedItem = findItem(point: location) else { return }
        
        matchedItems.removeAll()
        findMatch(currentItem: tappedItem)
        removeMatches()
        moveDown()
    }
    
    func moveDown() {
        for (columnIndex, column) in columns.enumerated() {
            for (rowIndex, item) in column.enumerated() {
                item.row = rowIndex
                
                let downAction = SKAction.move(to: positionItem(for: item), duration: 0.3)
                item.run(downAction)
            }
            
            while columns[columnIndex].count < itemsPerRow {
                let item = createItem(column: columnIndex, row: columns[columnIndex].count, startOffScreen: true)
                
                columns[columnIndex].append(item)
            }
        }
    }
}

extension GameScene {
    func moveCountDown() {
        moves -= 1
        
        if moves == 0 {
            isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.gameOver()
            }
        }
    }
    
    func scoreUp() {
        let matchCount = matchedItems.count
        let finalCount = min(matchCount, 6)
        let scoreToAdd = pow(2, Double(finalCount))
        score += Int(scoreToAdd)
    }
    
    func gameOver() {
        gameoverImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameoverImage.size = self.size
        gameoverImage.zPosition = 2
        
        addChild(gameoverImage)
        
        restartButton.size = CGSize(width: size.width / 5, height: size.width / 5)
        restartButton.position = CGPoint(x: 0, y: -(size.height / 6))
        restartButton.zPosition = 3
        
        restartButton.touchAction = { [weak self] in
            self?.score = 0
            self?.moves = 10
            self?.isUserInteractionEnabled = true
            self?.gameoverImage.removeFromParent()
        }
        
        
    }
}

#Preview {
    ContentView()
}
