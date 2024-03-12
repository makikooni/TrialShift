//
//  GameScene.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 07/03/2024.
//

//1. Update the sprite when game over
//2. Update sprite so it carries a bucket ? 
//3. Add Welcome Screen
//4. Change bubble sound to kitchen sounds
//5. Change background music sound
//5.icon
//6. resize the textures of characters and remove scaling to avoid difference with physics body
//DONE ---- 7. repair drops vanishing after head and sound
//DONE ---- 9. splash no longer visible ? ? ?? ?
//10. beggining of new level- change audio of muble
//11. change main font
//12. update banner
//13. add flying cupcake (138)
//14. Repair graphic for water and make it bigger
//DONE ---- 15. Repair foreground placing

import AVFoundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameInProgress = false
    var missed: Int = 0
    let player = Player()
    let playerSpeed: CGFloat = 1.5
    // Player movement
    var movingPlayer = false 
    var lastPosition: CGPoint?
    var level: Int = 1 { 
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    var score: Int = 0 { 
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var numberOfDrops: Int = 10
    var dropsExpected = 10
    var dropsCollected = 0
    var dropSpeed: CGFloat = 1.0
    var minDropSpeed: CGFloat = 0.12 // (fastest drop) 
    var maxDropSpeed: CGFloat = 1.0 // (slowest drop)
    
    // Labels
    var scoreLabel: SKLabelNode = SKLabelNode() 
    var levelLabel: SKLabelNode = SKLabelNode()
    let musicAudioNode = SKAudioNode(fileNamed: "music.mp3")
    let bubblesAudioNode = SKAudioNode(fileNamed: "bubbles.mp3")
    var prevDropLocation: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        
        // Decrease the audio engine's volume
        audioEngine.mainMixerNode.outputVolume = 0.0
        
        // Run a delayed action to add bubble audio to the scene
        run(SKAction.wait(forDuration: 1.5), completion: { [unowned self] in
            self.bubblesAudioNode.autoplayLooped = true
            self.addChild(self.bubblesAudioNode)
        })

        
        // Set up the background music audio node
        musicAudioNode.autoplayLooped = true
        musicAudioNode.isPositional = false
        
        
        // Add the audio node to the scene
        addChild(musicAudioNode)
        
        // Use an action to adjust the audio node's volume to 0
        musicAudioNode.run(SKAction.changeVolume(to: 0.0, duration: 0.0))
        // Run a delayed action on the scene that fades in the music
        run(SKAction.wait(forDuration: 1.0), completion: { [unowned self] in self.audioEngine.mainMixerNode.outputVolume = 1.0
            self.musicAudioNode.run(SKAction.changeVolume(to: 0.75, duration: 2.0))
        })
        
        // Set up the physics world contact delegate
        physicsWorld.contactDelegate = self
        
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
        foreground.position = CGPoint(x: 0, y: 60)
        
        
        // Add physics body
        foreground.physicsBody = SKPhysicsBody(edgeLoopFrom: foreground.frame)
        foreground.physicsBody?.affectedByGravity = false
        addChild(foreground)
        
        // Set up the banner
        let banner = SKSpriteNode(imageNamed: "banner")
        banner.zPosition = Layer.background.rawValue + 1 
        banner.position = CGPoint(x: frame.midX, y: viewTop() - 20)
        banner.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        addChild(banner)
        
        // Set up physics categories for contacts
        foreground.physicsBody?.categoryBitMask = PhysicsCategory.foreground
        foreground.physicsBody?.contactTestBitMask = PhysicsCategory.collectible
        foreground.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        
        // Set up User Interface
        setupLabels()
        
        // Set up player
        player.setupConstraints(floor: foreground.frame.maxY)
        player.position = CGPoint(x: size.width/2, y: foreground.frame.maxY)
        addChild(player)
        player.walk()
        
        //Set up Game
        //spawnMultipleWater()
        
       //Show message
        showMessage("Tap to start game")
        
    }
    func setupLabels() {
    /* SCORE LABEL */
    scoreLabel.name = "score"
    scoreLabel.fontName = "Helvetica-Bold"
    scoreLabel.fontColor = .black
    scoreLabel.fontSize = 35.0
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.verticalAlignmentMode = .center
    scoreLabel.zPosition = Layer.ui.rawValue
    scoreLabel.position = CGPoint(x: frame.maxX - 50, y: viewTop() - 35)
    
    // Set the text and add the label node to scene
    scoreLabel.text = "Score: 0" 
    addChild(scoreLabel)
      
    /* LEVEL LABEL */
    levelLabel.name = "level"
    levelLabel.fontName = "Helvetica-Bold"
    levelLabel.fontColor = .black
    levelLabel.fontSize = 35.0
    levelLabel.horizontalAlignmentMode = .right
    levelLabel.verticalAlignmentMode = .center
    levelLabel.zPosition = Layer.ui.rawValue
    levelLabel.position = CGPoint(x: frame.maxX - 50, y: viewTop() - 80)
      // Set the text and add the label node to scene
    levelLabel.text = "Level: \(level)"
    addChild(levelLabel) }
    
    func showMessage(_ message: String) {
        // Set up message label
        let messageLabel = SKLabelNode()
        messageLabel.name = "message"
        messageLabel.position = CGPoint(x: frame.midX, y: player.frame.maxY + 100)
        messageLabel.zPosition = Layer.ui.rawValue
        messageLabel.numberOfLines = 2
        
        // Set up attributed text
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .backgroundColor: UIColor.clear,
            .font: UIFont(name: "Helvetica-Bold", size: 45.0)!,
            .paragraphStyle: paragraph
        ]
        messageLabel.attributedText = NSAttributedString(string:
                                                            message, attributes: attributes)
        // Run a fade action and add the label to the scene
        messageLabel.run(SKAction.fadeIn(withDuration: 0.25))
        addChild(messageLabel)
    }
     
    func hideMessage() {
        // Remove message label if it exists
        if let messageLabel = childNode(withName: "//message") as? SKLabelNode {
            messageLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.removeFromParent()]))
        }
    }

    // MARK: - GAME FUNCTIONS
    /* ####################################################################### */
    /*                      GAME FUNCTIONS START HERE                          */
    /* ####################################################################### */
    
    func spawnMultipleWater() {
        player.mumble()
        // Start player walk animation
        player.walk()
        // Reset the level and score
        if gameInProgress == false { score = 0
        level = 1
        }

        
        // Set number of drops based on the level
        switch level {
        case 1, 2, 3:
        numberOfDrops = level * 10
        case 4:
        numberOfDrops = 35
        case 5:
        numberOfDrops = 40
        case 6:
        numberOfDrops = 45
        case 7:
        numberOfDrops = 50
        case 8:
        numberOfDrops = 55
        default:
        numberOfDrops = 55
        }
        
        // Reset and update the collected and expected drop count
        dropsCollected = 0
        dropsExpected = numberOfDrops
        
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
        let spawnSequence = SKAction.sequence([spawn, wait])
        let repeatAction = SKAction.repeat(spawnSequence, count: numberOfDrops)

        // Create a custom action to call checkForRemainingDrops
        let callCheckAction = SKAction.run { [unowned self] in self.checkForRemainingDrops() }

        // Add a delay of 2 seconds before calling checkForRemainingDrops ( so the last drop can drop fully)
        let delayAction = SKAction.wait(forDuration: 2.0)

        // Run action
        let sequence = SKAction.sequence([repeatAction, delayAction, callCheckAction])
        run(sequence, withKey: "drop")
        
        gameInProgress = true
        
    
        //Hide message
        hideMessage()
    }
    
    func spawnWater() {
        let collectible = Collectible(collectibleType: CollectibleType.water)
        
        
        // set random position
        let margin = (collectible.size.width/5) * 1.5
        let dropRange = SKRange(lowerLimit: frame.minX + margin,
                                upperLimit: frame.maxX - margin)
        
        var randomX = CGFloat.random(in:
                                        dropRange.lowerLimit...dropRange.upperLimit)
        
        /* START ENHANCED DROP MOVEMENT
         this helps to create a "snake-like" pattern */
        // Set a range
        let randomModifier = SKRange(lowerLimit: 50 + CGFloat(level), upperLimit: 60 * CGFloat(level))
        var modifier = CGFloat.random(in: randomModifier.lowerLimit...randomModifier.upperLimit)
        if modifier > 400 { modifier = 400 }
        
        // Set the previous drop location
        if prevDropLocation == 0.0 { prevDropLocation = randomX
        }
        
        // Clamp its x-position
        if prevDropLocation < randomX {
        randomX = prevDropLocation + modifier
        } else {
        randomX = prevDropLocation - modifier
        }
        // Make sure the collectible stays within the frame
        if randomX <= (frame.minX + margin) { randomX = frame.minX + margin
        } else if randomX >= (frame.maxX - margin) { randomX = frame.maxX - margin
        }
        
        // Store the location
        prevDropLocation = randomX
        /* END ENHANCED DROP MOVEMENT */
        
        // Add the number tag to the collectible drop
        let xLabel = SKLabelNode()
        xLabel.name = "dropNumber"
        xLabel.fontName = "Helvetica-Bold"
        xLabel.fontColor = UIColor.black
        xLabel.fontSize = 100.0
        xLabel.text = "\(numberOfDrops)"
        xLabel.position = CGPoint(x: 0, y: 30)
        collectible.addChild(xLabel)
        numberOfDrops -= 1 // decrease drop count by 1
        
        collectible.position = CGPoint(x: randomX,
                                       y: player.position.y * 2.6)
        
        // Set scale to make it 5 times smaller
        collectible.setScale(0.2) // 1/5 of the original size
        
        addChild(collectible)
        
        //Changing the floorLevel value etc
        collectible.drop(dropSpeed: TimeInterval(1.0),floorLevel: player.frame.minY + 40)

      
    }
    
    func checkForRemainingDrops() {
    if dropsCollected >= (dropsExpected - 3) {
    // if dropsCollected >= (dropsExpected - 3) {

        nextLevel() }
    }
    // Player PASSED level
    func nextLevel() {
        missed = 0
        //Show message
        showMessage("Get Ready!")
        let wait = SKAction.wait(forDuration: 2.25)
        run(wait, completion:{[unowned self] in self.level += 1
            
            self.spawnMultipleWater()})
    }
    
    // Player FAILED level
    //FIGURE OUT WHY DROPS ARE NOT STOPING TO DROP
    func gameOver() {
        missed = 0
        //Show message
        showMessage("Game Over\nTap to try again")
        // Update game states
        gameInProgress = false
        
        // Start player die animation
        player.die()
        // Remove repeatable action on main scene
        removeAction(forKey: "drop")
        // Loop through child nodes and stop actions on collectibles
        enumerateChildNodes(withName: "//co_*") { (node, stop) in
            // Check if the node's name starts with "co_" and its texture is not equal to the excluded texture
            if let spriteNode = node as? SKSpriteNode,
               node.name?.starts(with: "co_") == true,
               let nodeTexture = spriteNode.texture,
               nodeTexture.description != SKTexture(imageNamed: "water_1").description {
                // Stop and remove drops
                node.removeAction(forKey: "drop") // remove action
                node.physicsBody = nil // remove body so no collisions occur
                // Remove the node from the scene
                node.removeFromParent()
            }
        }
        
        // Reset game
        resetPlayerPosition() 
        popRemainingDrops()
        
    }

    
    func resetPlayerPosition() {
        let resetPoint = CGPoint(x: frame.midX, y: player.position.y)
        let distance = hypot(resetPoint.x-player.position.x, 0)
        let calculatedSpeed = TimeInterval(distance / (playerSpeed * 2)) / 255

        if player.position.x > frame.midX { player.moveToPosition(pos: resetPoint, direction: "L",
                                                                  speed: calculatedSpeed)
            
        } else {
            player.moveToPosition(pos: resetPoint, direction: "R",
                                  speed: calculatedSpeed)
        }
        }
    
    func popRemainingDrops() {
        var i = 0
        enumerateChildNodes(withName: "//co_*") {
            (node, stop) in
            // Pop remaining drops in sequence
            let initialWait = SKAction.wait(forDuration: 1.0)
            let wait = SKAction.wait(forDuration: TimeInterval(0.15 * CGFloat(i)))
            let removeFromParent = SKAction.removeFromParent()
            let actionSequence = SKAction.sequence([initialWait, wait, removeFromParent])
            node.run(actionSequence)
            
            i += 1
        }
    }
    
    // MARK: - TOUCH HANDLING
    /* ####################################################################### */
    /*                        TOUCH HANDLERS STARTS HERE                       */
    /* ####################################################################### */
    func touchDown(atPoint pos: CGPoint) { let touchedNode = atPoint(pos)
    if touchedNode.name == "player" {
        
        
        if gameInProgress == false {
            spawnMultipleWater()
            return
        }
        
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
    
    //override func update(_ currentTime: TimeInterval) { checkForRemainingDrops()
    //}
}


// MARK: - COLLISION DETECTION
/* ####################################################################### */
/*                 COLLISION DETECTION METHODS START HERE                  */
/* ####################################################################### */
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Check collision bodies
        let collision = contact.bodyA.categoryBitMask |
        contact.bodyB.categoryBitMask
        // Did the [PLAYER] collide with the [COLLECTIBLE]?
        if collision == PhysicsCategory.player  | PhysicsCategory.collectible { print("player hit collectible")
            // Find out which body is attached to the collectible node
            let body = contact.bodyA.categoryBitMask == PhysicsCategory.collectible ?
            contact.bodyA.node :
            contact.bodyB.node
                // Verify the object is a collectible
                if let sprite = body as? Collectible {
                    sprite.collected()
                    dropsCollected += 1
                    score += 1
                    
                    // Add the 'chomp' text at the player's position
                    let chomp = SKLabelNode(fontNamed: "Helvetica-Bold")
                    chomp.name = "chomp"
                    chomp.alpha = 0.0
                    chomp.fontSize = 50.0
                    chomp.text = "YAY!!"
                    chomp.horizontalAlignmentMode = .center
                    chomp.verticalAlignmentMode = .bottom
                    chomp.position = CGPoint(x: player.position.x, y: player.frame.maxY + 25) 
                    chomp.zRotation = CGFloat.random(in: -0.15...0.15)
                    addChild(chomp)
                    
                    // Add actions to fade in, rise up, and fade out
                    let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.05)
                    let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.45)
                    let moveUp = SKAction.moveBy(x: 0.0, y: 45, duration: 0.45)
                    let groupAction = SKAction.group([fadeOut, moveUp])
                    let removeFromParent = SKAction.removeFromParent()
                    let chompAction = SKAction.sequence([fadeIn, groupAction, removeFromParent])
                    chomp.run(chompAction)
                    
                    //score += level
                }
            }
            
        
        // Or did the [COLLECTIBLE] collide with the [FOREGROUND]?
        if collision == PhysicsCategory.foreground + UInt32(0.01) | PhysicsCategory.collectible { print("collectible hit foreground")
            
            // Find out which body is attached to the collectible node
            let body = contact.bodyA.categoryBitMask == PhysicsCategory.collectible ?
            contact.bodyA.node :
            contact.bodyB.node
            // Verify the object is a collectible
            if let sprite = body as? Collectible {
                missed += 1
                sprite.missed()
                
                if missed >= 3{
                    gameOver()
                    
                    
                }
                
            }
        }
    }
}

