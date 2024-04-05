//
//  GameTwo.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 03/04/2024.
//

// 1. repair visibility of labels
// 2. Add music
// 3. Repair uneven size of chocolates
// 4. Add starting message
// 5. Add clock
// 6. Game Over after 60 sec


import AVFoundation
import SpriteKit
import GameplayKit

class GameTwo: SKScene {
    let player = PlayerHead()
    var movingPlayer = false
    var righthand = false
    var lefthand = false
    var count = 0
    var collectible: Collectible2?
    var color: Bool?
    var isCollectibleActive = false

    
    
    //LABELS
    var scoreLabel: SKLabelNode = SKLabelNode()
    var levelLabel: SKLabelNode = SKLabelNode()
    
    //VARIABLES
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
    
    // MARK: - SET UP

    override func didMove(to view: SKView) {
        
        //self.scaleMode = .aspectFit
        
        
        // AUDIO
        
        // BACKGROUND
        let background = SKSpriteNode(imageNamed: "background_03")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = Layer.background.rawValue
        background.position = CGPoint(x: 0, y: 0)
        addChild(background)
        
        // BANNER
        let banner = SKSpriteNode(imageNamed: "banner_02")
        banner.zPosition = Layer.background.rawValue + 1
        banner.position = CGPoint(x: frame.midX, y: viewTop() - 120)
        banner.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        banner.xScale = 1.5 // Increase width scale
        banner.yScale = 1.5
        addChild(banner)
        
        
        
        // USER INTERFACE
        setupLabels()
        //showMessage("TAP TO START")
        
        // SET UP PLAYER
        player.setupConstraints(floor: frame.minY + 370)
        // check minY later here - >
        player.position = CGPoint(x: size.width/2, y: frame.minY + 370)
        addChild(player)
        
        
        spawnChocolate()

        
        
    }
    
    func setupLabels() {
        scoreLabel.name = "score"
        scoreLabel.fontName = "ChalkboardSE-Bold"
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 65.0
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.zPosition = Layer.ui.rawValue
        scoreLabel.position = CGPoint(x: frame.maxX - 230, y: viewTop() - 120)
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        levelLabel.name = "level"
        levelLabel.fontName = "ChalkboardSE-Bold"
        levelLabel.fontColor = .white
        levelLabel.fontSize = 65.0
        levelLabel.horizontalAlignmentMode = .right
        levelLabel.verticalAlignmentMode = .center
        levelLabel.zPosition = Layer.ui.rawValue
        levelLabel.position = CGPoint(x: frame.maxX - 230, y: viewTop() - 200)
        // Set the text and add the label node to scene
        levelLabel.text = "Level: \(level)"
        addChild(levelLabel) }
    
    
    func showMessage(){
    //UPDATE
    }
    
    
    
    // MARK: - GAME FUNCTIONS
    
    func spawnChocolate() {
        guard !isCollectibleActive else { return }

           // Generate a random number to determine chocolate type
           let random = Int.random(in: 1...2)  // Generates either 1 or 2 (for dark or white chocolate)
           
           // Determine the collectible type based on the random number
           var collectibleType: CollectibleType2 = .dark_chocolate
           
           switch random {
           case 1:
               collectibleType = .dark_chocolate
               color = true
               print("Spawned dark chocolate")
           case 2:
               collectibleType = .white_chocolate
               color = false
               print("Spawned white chocolate")
           default:
               break
           }
           
           // Create a new collectible instance
           collectible = Collectible2(collectibleType2: collectibleType)
           
           // Add collectible to scene
           if let collectible = collectible {
               addChild(collectible)
               count += 1
               print("Spawned")
               print(collectible.position)
               isCollectibleActive = true

           }
       }
       
    
    func gameLogic() {
        //unpacking optional boolean value 
        if let color = color {
            if lefthand && color {
                lefthand = false
                score += 1
                print("Left hand action completed")
                
                if let collectible = collectible {
                    let moveAction = SKAction.moveBy(x: -300, y: 0, duration: 0.5)
                    
                    let sequenceAction = SKAction.sequence([
                        moveAction,
                        SKAction.run {
                            collectible.removeFromParent()
                            

                        }
                    ])
                    
                    // Run the sequence action on the collectible
                    collectible.run(sequenceAction)
                    isCollectibleActive = false

                    
                    // Schedule the next spawn after a delay (e.g., 1.0 second)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.spawnChocolate() // Spawn a new collectible after the delay
                    }
                }
                
            } else if righthand && !color{
                righthand = false
                score += 1
                print("Right hand action completed")
                
                if let collectible = collectible {
                    let moveAction = SKAction.moveBy(x: 300, y: 0, duration: 0.5)
                    
                    let sequenceAction = SKAction.sequence([
                        moveAction,
                        SKAction.run {
                            collectible.removeFromParent()
                        }
                    ])
                    
                    // Run the sequence action on the collectible
                    collectible.run(sequenceAction)
                    isCollectibleActive = false

                    // Schedule the next spawn after a delay (e.g., 1.0 second)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.spawnChocolate() // Spawn a new collectible after the delay
                    }
                }
            }
            
            else if righthand || lefthand{
                righthand = false
                lefthand = false
                if let collectible = collectible {
                    let moveAction = SKAction.moveBy(x: 0, y: -150, duration: 0.5)
                    
                    let sequenceAction = SKAction.sequence([
                        moveAction,
                        SKAction.run {
                            collectible.removeFromParent()
                        }
                    ])
                    
                    // Run the sequence action on the collectible
                    collectible.run(sequenceAction)
                    isCollectibleActive = false

                    // Schedule the next spawn after a delay (e.g., 1.0 second)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.spawnChocolate() // Spawn a new collectible after the delay
                    }
                }
            } }
    }

    
    func sentFlyingToad() {
    //UPDATE
    }
    
    func gameOver() {
    //UPDATE based on time clock
    }
    
    
    
    
    // MARK: - TOUCH HANDLING
    
    func touchUp(atPoint pos: CGPoint) { movingPlayer = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        let halfScreenWidth = self.size.width / 2
        print(touchLocation)
        if touchLocation.x < halfScreenWidth {
            // Touch on the left side
            print("Touch on the left side")
            // Perform action A here
            player.leftHandMove() // Call right hand move method on the player instance
            lefthand = true
        } else {
            // Touch on the right side
            print("Touch on the right side")
            // Perform action B here
            player.rightHandMove() // Call left hand move method on the player instance
            righthand = true
        }
    }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event:
                                   UIEvent?) {
            for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        }
        override func touchesCancelled(_ touches: Set<UITouch>,
                                       with event: UIEvent?) {
            
            for t in touches { self.touchUp(atPoint: t.location(in: self)) } }
        
        override func update(_ currentTime: TimeInterval) {
            gameLogic()
        }
    }
    
    

