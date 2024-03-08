//
//  GameScene.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 07/03/2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let player = Player()
    let playerSpeed: CGFloat = 1.5
    // Player movement
    var movingPlayer = false 
    var lastPosition: CGPoint?
    var level: Int = 8
    
    var numberOfDrops: Int = 10
    var dropSpeed: CGFloat = 1.0
    var minDropSpeed: CGFloat = 0.12 // (fastest drop) 
    var maxDropSpeed: CGFloat = 1.0 // (slowest drop)
    
    
    override func didMove(to view: SKView) {
        
        // Set up background
        let background = SKSpriteNode(imageNamed: "background_01")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = Layer.background.rawValue
        background.position = CGPoint(x: 0, y: 0)
        addChild(background)

        
        // Set up foreground
        let foreground = SKSpriteNode(imageNamed: "foreground_01")
        foreground.anchorPoint = CGPoint(x: 0, y: 0)
        foreground.zPosition = Layer.foreground.rawValue
        foreground.position = CGPoint(x: 0, y: 200) //change when proper assets added
        addChild(foreground)
        
        
        // Set up player
        player.setupConstraints(floor: foreground.frame.maxY)
        player.position = CGPoint(x: size.width/2, y: foreground.frame.maxY)
        addChild(player)
        player.walk()
        
        //Set up Game
        spawnMultipleWater()
        
        
        
    }
    
    // MARK: - GAME FUNCTIONS
    /* ####################################################################### */
    /*                      GAME FUNCTIONS START HERE                          */
    /* ####################################################################### */
    
    func spawnMultipleWater() {
        
        // Set number of drops based on the level
        switch level {
        case 1, 2, 3, 4, 5:
        numberOfDrops = level * 10 
        case 6:
        numberOfDrops = 75 
        case 7:
        numberOfDrops = 100 
        case 8:
        numberOfDrops = 150 
        default:
        numberOfDrops = 150
        }
        
        // Set up drop speed
        dropSpeed = 1 / (CGFloat(level) + (CGFloat(level) /
                                           CGFloat(numberOfDrops)))
        if dropSpeed < minDropSpeed {
            dropSpeed = minDropSpeed
        } else if dropSpeed > maxDropSpeed {
            dropSpeed = maxDropSpeed
        }
        
        // Set up repeating action
        let wait = SKAction.wait(forDuration: TimeInterval(dropSpeed))
        let spawn = SKAction.run { [unowned self] in self.spawnWater() }
        let sequence = SKAction.sequence([wait, spawn])
        let repeatAction = SKAction.repeat(sequence, count: numberOfDrops)
        
        // Run action
        run(repeatAction, withKey: "drop")
    }
    
    func spawnWater() {
        let collectible = Collectible(collectibleType: CollectibleType.water)
        
        
        // set random position
        let margin = (collectible.size.width/5) * 1.5
        let dropRange = SKRange(lowerLimit: frame.minX + margin,
                                upperLimit: frame.maxX - margin)
        
        let randomX = CGFloat.random(in:
                                        dropRange.lowerLimit...dropRange.upperLimit)
        
        collectible.position = CGPoint(x: randomX,
                                       y: player.position.y * 2.25)
        
        // Set scale to make it 5 times smaller
        collectible.setScale(0.2) // 1/5 of the original size
        
        addChild(collectible)
        
        //Changing the floorLevel value etc
        collectible.drop(dropSpeed: TimeInterval(1.0), floorLevel: player.frame.minY + 40)
        
      
    }

    
    // MARK: - TOUCH HANDLING
    /* ####################################################################### */
    /*                        TOUCH HANDLERS STARTS HERE                       */
    /* ####################################################################### */
    func touchDown(atPoint pos: CGPoint) { let touchedNode = atPoint(pos)
    if touchedNode.name == "player" {
    movingPlayer = true }
    }
    
    func touchMoved(toPoint pos: CGPoint) { 
        if movingPlayer == true {
        // Clamp position
            let newPos = CGPoint(x: pos.x, y: player.position.y)
            player.position = newPos
        
            // Check last position; if empty set it
            let recordedPosition = lastPosition ?? player.position 
            if recordedPosition.x > newPos.x {
                player.xScale = -abs(xScale) } 
            else {
                player.xScale = abs(xScale) }
            // Save last known position
            lastPosition = newPos
      }
    }
    
    func touchUp(atPoint pos: CGPoint) { movingPlayer = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event:
                               UIEvent?) { for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event:
                               UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event:
                               UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {

        for t in touches { self.touchUp(atPoint: t.location(in: self)) } }
}

