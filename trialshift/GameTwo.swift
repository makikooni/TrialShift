//
//  GameTwo.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 03/04/2024.
//

// 1. repair visibility of labels
// 3. Repair uneven size of chocolates
// 5. Add a button when game_over

import AVFoundation
import SpriteKit
import GameplayKit

class GameTwo: SKScene {
    var gameInProgress = false
    let player = PlayerHead()
    var movingPlayer = false
    var righthand = false
    var lefthand = false
    var count = 0
    var collectible: Collectible2?
    var color: Bool?
    var isCollectibleActive = false
    var timer : Timer?
    
    
    //LABELS
    var scoreLabel: SKLabelNode = SKLabelNode()
    var clockLabel: SKLabelNode = SKLabelNode()
    
    //VARIABLES
    let musicAudioNode = SKAudioNode(fileNamed: "music.mp3")
    let kitchenAudioNode = SKAudioNode(fileNamed: "kitchen.mp3")
    
    //PROPERTY OBSERVERS
    var time: Int = 60 {
        didSet {
            clockLabel.text = "Time left: \(time)"
            if time == 0{
                timeUp()
            }
        }
    }
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // MARK: - SET UP

    override func didMove(to view: SKView) {
        setupLabels()
        showMessage("TAP TO START")
        spawnChocolate()
        //FIGURE OUT HOW TO START ONLY AFTER MESSAGE VANISHES 
        startTimer()
        
        // AUDIO
        musicAudioNode.autoplayLooped = true
        musicAudioNode.isPositional = false
        addChild(musicAudioNode)
        musicAudioNode.run(SKAction.changeVolume(to: 0.0, duration: 0.0))
        run(SKAction.wait(forDuration: 1.0), completion: { [unowned self] in self.audioEngine.mainMixerNode.outputVolume = 1.0
            self.musicAudioNode.run(SKAction.changeVolume(to: 0.1, duration: 2.0))
        })
        
        
        
        
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
        
                
        // SET UP PLAYER
        player.setupConstraints(floor: frame.minY + 370)
        // check minY later here - >
        player.position = CGPoint(x: size.width/2, y: frame.minY + 370)
        addChild(player)
        
        
    }
    //TIMER
    func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                self.time -= 1
            }
        }
        
        func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
        
        func timeUp() {
            stopTimer()
            gameOver()
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
        
        clockLabel.name = "clock"
        clockLabel.fontName = "ChalkboardSE-Bold"
        clockLabel.fontColor = .white
        clockLabel.fontSize = 65.0
        clockLabel.horizontalAlignmentMode = .right
        clockLabel.verticalAlignmentMode = .center
        clockLabel.zPosition = Layer.ui.rawValue
        clockLabel.position = CGPoint(x: frame.maxX - 230, y: viewTop() - 200)
        // Set the text and add the label node to scene
        clockLabel.text = "Time left: \(time)"
        addChild(clockLabel) }
    
    
    func showMessage(_ message: String) {
        // Set up message label
        let messageLabel = SKLabelNode()
        messageLabel.name = "message"
        messageLabel.position = CGPoint(x: frame.midX, y: player.frame.maxY + 350)
        messageLabel.zPosition = Layer.ui.rawValue
        messageLabel.numberOfLines = 2
        
        // Set up attributed text
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .backgroundColor:  UIColor(red: 0x50/255.0, green: 0x9c/255.0, blue: 0x9c/255.0, alpha: 1.0),
            .font: UIFont(name: "ChalkboardSE-Bold", size: 90.0)!,
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
        showMessage("GAME OVER")
        //ADD A BUTTON?
        //let gamescene = GameScene(size: self.size)
        //gamescene.scaleMode = .aspectFill
        //self.view?.presentScene(gamescene)
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
        hideMessage()
        
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
    
    

