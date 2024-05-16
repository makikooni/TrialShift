//
//  GameTwo.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 03/04/2024.
//


import AVFoundation
import SpriteKit
import GameplayKit

class GameTwo: SKScene {
    let player = PlayerHead()
    var newscore = ""
    var movingPlayer = false
    var righthand = false
    var gameover = false
    var lefthand = false
    var count = 0
    var collectible: Collectible2?
    var color: Bool?
    var isCollectibleActive = false
    var timer : Timer?
    var backToMainScreenButton: SKSpriteNode?
    private let playCollectSound = SKAction.playSoundFileNamed("collect.wav", waitForCompletion: false)
    
    
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
    
    var fails: Int = 0 {
        didSet {
            if fails >= 3{
                gameOver()
            }
        }
    }
    
    // MARK: - SET UP
    
    override func didMove(to view: SKView) {
        setupLabels()
        showMessage("TAP TO START")
        spawnChocolate()
        
        //FIGURE OUT HOW TO START ONLY AFTER MESSAGE VANISHES; then remove below
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // Start the timer after a delay of 5 seconds
            self.startTimer()
        }
        
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
    // The game features a timer that counts down the player's time allowance
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.time -= 1
        }
    }
    
    // Function used to prevent timer going below zero
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Function used to run gameover() when timer reaches 0
    func timeUp() {
        stopTimer()
        gameOver()
        
        
    }
    
    // Function used to set up visuals of labels
    func setupLabels() {
        scoreLabel.name = "score"
        scoreLabel.fontName = "ChalkboardSE-Bold"
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 65.0
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.zPosition = Layer.ui.rawValue
        scoreLabel.position = CGPoint(x: frame.maxX - 230, y: viewTop() - 470)
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        clockLabel.name = "clock"
        clockLabel.fontName = "ChalkboardSE-Bold"
        clockLabel.fontColor = .white
        clockLabel.fontSize = 65.0
        clockLabel.horizontalAlignmentMode = .right
        clockLabel.verticalAlignmentMode = .center
        clockLabel.zPosition = Layer.ui.rawValue
        clockLabel.position = CGPoint(x: frame.maxX - 230, y: viewTop() - 550)
        // Set the text and add the label node to scene
        clockLabel.text = "Time left: \(time)"
        addChild(clockLabel) }
    
    
    func showMessage(_ message: String) {
        // Set up message label
        let messageLabel = SKLabelNode()
        messageLabel.name = "message"
        messageLabel.position = CGPoint(x: frame.midX, y: player.frame.maxY + 320)
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
            // Define an array of possible texts
            let texts = ["YAY!", "HURRAY!", "WOW!", "AWESOME!","COOL!"]
            
            // Keep track of the index of the last displayed text
            var lastIndex = UserDefaults.standard.integer(forKey: "lastIndex") // Retrieve the last index from UserDefaults
            
            // Get the next text to display
            let nextText = texts[lastIndex]
            
            // Create the chomp label with the next text
            let chomp = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
            chomp.name = "chomp"
            chomp.alpha = 0.0
            chomp.fontSize = 50.0
            chomp.text = nextText
            chomp.horizontalAlignmentMode = .center
            chomp.verticalAlignmentMode = .bottom
            chomp.position = CGPoint(x: player.position.x, y: player.frame.maxY + 25)
            chomp.zRotation = CGFloat.random(in: -0.15...0.15)
            addChild(chomp)
            
            // Update the index for the next cycle
            lastIndex = (lastIndex + 1) % texts.count
            
            // Save the updated index to UserDefaults
            UserDefaults.standard.set(lastIndex, forKey: "lastIndex")
            
            // Add actions to fade in, rise up, and fade out
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.05)
            let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.45)
            let moveUp = SKAction.moveBy(x: 0.0, y: 45, duration: 0.45)
            let groupAction = SKAction.group([fadeOut, moveUp])
            let removeFromParent = SKAction.removeFromParent()
            let chompAction = SKAction.sequence([fadeIn, groupAction, removeFromParent])
            
            let actionGroup = SKAction.group([playCollectSound, removeFromParent])
            
            if lefthand && color {
                lefthand = false
                score += 1
                print("Left hand action completed")
                chomp.run(chompAction)
                self.run(actionGroup)
                
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.spawnChocolate() // Spawn a new collectible after the delay
                        
                        
                    }}
                
            } else if righthand && !color{
                righthand = false
                score += 1
                print("Right hand action completed")
                chomp.run(chompAction)
                self.run(actionGroup)
                
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.spawnChocolate() // Spawn a new collectible after the delay
                    }
                }
            }
            
            else if righthand || lefthand{
                righthand = false
                lefthand = false
                fails += 1
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.spawnChocolate() // Spawn a new collectible after the delay
                    }
                }
            } }
    }
    
    
    
    
    func setupBackToMainScreenButton() {
        // Configure the button
        backToMainScreenButton = SKSpriteNode(imageNamed: "backToMainScreenButton")
        backToMainScreenButton?.name = "backToMainScreen"
        backToMainScreenButton?.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        backToMainScreenButton?.zPosition = Layer.ui.rawValue + 1
        backToMainScreenButton?.setScale(2.5)
        addChild(backToMainScreenButton!)
    }

    func removeBackToMainScreenButton() {
        // Remove the button from the scene
        backToMainScreenButton?.removeFromParent()
        backToMainScreenButton = nil
    }
    
    func scoreRecount(){
        if score >= 85{
            newscore = "A"
        } else if score >= 75{
            newscore = "B"
        } else if score >= 65{
            newscore = "C"
        } else if score >= 50{
            newscore = "D"
        } else if score >= 40{
            newscore = "E"
        } else if score <= 39{
            newscore = "F"
        }}
    
    func gameOver() {
        gameover = true
        scoreRecount()
        //print(newscore)
        showMessage("GAME OVER")
        stopTimer()
        isCollectibleActive = false
        setupBackToMainScreenButton()

    }
        
    
    // MARK: - TOUCH HANDLING
    
    func touchUp(atPoint pos: CGPoint) { movingPlayer = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Check if the game is over and the button is present
        guard gameover, let backToMainScreenButton = backToMainScreenButton else {
            // Your existing touch handling logic for player's movement
            for touch in touches {
                guard !gameover else { return } // Ignore touches if game is over
                
                let touchLocation = touch.location(in: self)
                let halfScreenWidth = self.size.width / 2
                
                if touchLocation.x < halfScreenWidth {
                    // Touch on the left side
                    player.leftHandMove()
                    lefthand = true
                } else {
                    // Touch on the right side
                    player.rightHandMove()
                    righthand = true
                }
                
                if !gameover {
                    gameLogic() // Only call game logic if the game is not over
                }
                
                hideMessage()
            }
            return
        }
        
        // Iterate through all touches
        for touch in touches {
            let location = touch.location(in: self)
            
            // Check if the touch is on the backToMainScreenButton
            if backToMainScreenButton.contains(location) {
                // Transition to another scene when the button is tapped
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameover else { return } // Ignore touches if game is over
        
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
        if !gameover {
            gameLogic() // Only call game logic if the game is not over
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameover else { return } // Ignore touches if game is over
        
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
        if !gameover {
            gameLogic() // Only call game logic if the game is not over
        }
    }
}
