//
//Description: 4 chefs are working hard and asking you to bring them ingredients (sugar, milk, water, chocolate) be fast! run to the store and bring the correct items.

import AVFoundation
import SpriteKit
import GameplayKit


class GameThree: SKScene {
    let player = Player3()
    var gameInProgress = false
    var gameover = false
    var isCollectibleActive = true
    var score = ""
    var movingPlayer = false
    var lastPosition: CGPoint?
    var timer : Timer?
    var backToMainScreenButton: SKSpriteNode?
    var collectible: Collectible3?
    var color: Bool?
    let verticalSpeed: CGFloat = 150.0
    var requestcount = 0
    var requestedby = ""
    var requestedCollectible = ""
    
    //LABELS
    var requestsLabel: SKLabelNode = SKLabelNode()
    var clockLabel: SKLabelNode = SKLabelNode()
    
    //VARIABLES
    let musicAudioNode = SKAudioNode(fileNamed: "music.mp3")
    let kitchenAudioNode = SKAudioNode(fileNamed: "kitchen.mp3")
    
    //PROPERTY OBSERVERS
    var time: Int = 0 {
        didSet {
            clockLabel.text = "Time passed: \(time)"
        }
    }
    var requests: Int = 20 {
        didSet {
            requestsLabel.text = "Items left: \(requests)"
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
        
        player.name = "player"

        // AUDIO
        musicAudioNode.autoplayLooped = true
        musicAudioNode.isPositional = false
        addChild(musicAudioNode)
        musicAudioNode.run(SKAction.changeVolume(to: 0.0, duration: 0.0))
        run(SKAction.wait(forDuration: 1.0), completion: { [unowned self] in
            self.audioEngine.mainMixerNode.outputVolume = 1.0
            self.musicAudioNode.run(SKAction.changeVolume(to: 0.1, duration: 2.0))
        })
        
        
        // BACKGROUND
        let background = SKSpriteNode(imageNamed: "background_04")
        background.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        background.zPosition = Layer.background.rawValue
        background.position = CGPoint(x: +85, y: 0)
        addChild(background)
        
        // BANNER
        let banner = SKSpriteNode(imageNamed: "banner_03")
        banner.zPosition = Layer.background.rawValue + 1
        banner.position = CGPoint(x: frame.midX + 780, y: viewTop() - 50)
        banner.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        banner.xScale = 1.5 // Increase width scale
        banner.yScale = 1.5
        addChild(banner)
        
        // PLAYER
        player.setupConstraints(floor: frame.minY + 370)
        let scaleFactor: CGFloat = 0.95 // Adjust this value as needed
        player.setScale(scaleFactor)
        // check minY later here - >
        player.position = CGPoint(x: size.width/2, y: frame.minY + 370)
        addChild(player)

        player.walk()
        
        // VISUALS
        setupLabels()
        showMessage("TAP TO START")
    }
    
    //TIMER
    // The game features a timer that counts amount of time that takes player to complete the task.
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.time += 1
        }
    }
    
    // Function used when player completes all the tasks.
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Function used to set up visuals of labels
    func setupLabels() {
        requestsLabel.name = "requests"
        requestsLabel.fontName = "ChalkboardSE-Bold"
        requestsLabel.fontColor = .white
        requestsLabel.fontSize = 65.0
        requestsLabel.horizontalAlignmentMode = .right
        requestsLabel.verticalAlignmentMode = .center
        requestsLabel.zPosition = Layer.ui.rawValue
        requestsLabel.position = CGPoint(x: frame.maxX - 230, y: viewTop() - 470)
        requestsLabel.text = "Request left: 20"
        addChild(requestsLabel)
        
        clockLabel.name = "clock"
        clockLabel.fontName = "ChalkboardSE-Bold"
        clockLabel.fontColor = .white
        clockLabel.fontSize = 65.0
        clockLabel.horizontalAlignmentMode = .right
        clockLabel.verticalAlignmentMode = .center
        clockLabel.zPosition = Layer.ui.rawValue
        clockLabel.position = CGPoint(x: frame.maxX - 230, y: viewTop() - 550)
        // Set the text and add the label node to scene
        clockLabel.text = "Time passed: \(time)"
        addChild(clockLabel) }
    
    
    func showMessage(_ message: String) {
        // Set up message label
        let messageLabel = SKLabelNode()
        messageLabel.name = "message"
        messageLabel.position = CGPoint(x: frame.midX, y: player.frame.maxY + -250)
        messageLabel.zPosition = Layer.ui.rawValue
        messageLabel.numberOfLines = 2
        
        // Set up attributed text
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
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
    
  
    func showChefA(){
        let chefAAtlas = SKTextureAtlas(named: "ChefA")
        var chefAFrames: [SKTexture] = []
        
        
        for index in 0...3 {
            let textureName = "chefA_\(index)"
            chefAFrames.append(chefAAtlas.textureNamed(textureName))
        }
        let chefA = SKSpriteNode(texture: chefAFrames[0])
        chefA.zPosition = Layer.foreground.rawValue
        chefA.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        chefA.position = CGPoint(x: frame.midX - 620,
                                y: frame.minY + 110)
        let scaleFactor: CGFloat = 1.3
        chefA.setScale(scaleFactor)
        addChild(chefA)
        print(chefA.position)
    }
        
        func showChefB(){
            let chefBAtlas = SKTextureAtlas(named: "ChefB")
            var chefBFrames: [SKTexture] = []
            for index in 0...3 {
                let textureName = "chefB_\(index)"
                chefBFrames.append(chefBAtlas.textureNamed(textureName))
            }
            
            let chefB = SKSpriteNode(texture: chefBFrames[0])
            chefB.zPosition = Layer.foreground.rawValue
            chefB.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            chefB.position = CGPoint(x: frame.midX + 850,
                                     y: frame.minY + 110)
            let scaleFactor: CGFloat = 1.3
            chefB.setScale(scaleFactor)
            addChild(chefB)
        }

        func showChefC(){
            let chefCAtlas = SKTextureAtlas(named: "ChefC")
            var chefCFrames: [SKTexture] = []
            
            for index in 0...3 {
                let textureName = "chefC_\(index)"
                chefCFrames.append(chefCAtlas.textureNamed(textureName))
            }
            let chefC = SKSpriteNode(texture: chefCFrames[0])
            chefC.zPosition = Layer.foreground.rawValue
            chefC.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            chefC.position = CGPoint(x: frame.midX + 230,
                                     y: frame.minY + 120)
            let scaleFactor: CGFloat = 1.3
            chefC.setScale(scaleFactor)
            addChild(chefC)
        }

    func sendGreenToad() {
        // Load sprite atlas
        let toadAtlas = SKTextureAtlas(named: "GreenToad")
        var toadFrames: [SKTexture] = []
        
        // Create array of textures from atlas
        for index in 0...5 {
            let textureName = "toad_\(index)"
            toadFrames.append(toadAtlas.textureNamed(textureName))
        }
        
        // Set up cake sprite node with initial texture
        let toad = SKSpriteNode(texture: toadFrames[0])
        toad.zPosition = Layer.foreground.rawValue
        toad.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        toad.position = CGPoint(x: frame.maxX + toad.size.width,
                                y: frame.midY - 350)
        let scaleFactor: CGFloat = 0.8
        toad.setScale(scaleFactor)
        addChild(toad)
        
        // Set up audio node and make it a child of the robot sprite node
        let audioNode = SKAudioNode(fileNamed: "quak.mp3")
        audioNode.autoplayLooped = true
        audioNode.run(SKAction.changeVolume(to: 1.0, duration: 0.0))
        toad.addChild(audioNode)
        
        
        // Create animation action
        let animateAction = SKAction.animate(with: toadFrames, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatForever(animateAction)
        toad.run(repeatAction)
        
        // Create and run a sequence of actions that moves the cake up and down
        let moveUp = SKAction.moveBy(x: 0, y: 15, duration: 0.25)
        let moveDown = SKAction.moveBy(x: 0, y: -15, duration: 0.25)
        let wobbleGroup = SKAction.sequence([moveDown, moveUp])
        let wobbleAction = SKAction.repeatForever(wobbleGroup)
        toad.run(wobbleAction)
        
        // Create an action that moves the cake left
        let moveLeft = SKAction.moveTo(x: frame.minX - toad.size.width, duration: 6.50)
        
        // Create an action to remove the cake sprite node
        let removeFromParent = SKAction.removeFromParent()
        
        // Combine the actions into a sequence
        let moveSequence = SKAction.sequence([moveLeft, removeFromParent])
        
        // Periodically run this method using a timed range
        toad.run(moveSequence, completion: {
            let wait = SKAction.wait(forDuration: 5, withRange: 15)
            let codeBlock = SKAction.run { self.sendGreenToad() }
            self.run(SKAction.sequence([wait, codeBlock]))
        })
    }
    
    
    func sendBrownToad() {
        // Load sprite atlas
        let toadAtlas = SKTextureAtlas(named: "BrownToad")
        var toadFrames: [SKTexture] = []
        
        // Create array of textures from atlas
        for index in 0...5 {
            let textureName = "brown_toad_\(index)"
            toadFrames.append(toadAtlas.textureNamed(textureName))
        }
        
        // Set up cake sprite node with initial texture
        let toad = SKSpriteNode(texture: toadFrames[0])
        toad.zPosition = Layer.foreground.rawValue
        toad.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        toad.position = CGPoint(x: frame.maxX + toad.size.width,
                                y: frame.midY - 450)
        let scaleFactor: CGFloat = 3.0
        toad.setScale(scaleFactor)
        addChild(toad)
        
        // Create animation action
        let animateAction = SKAction.animate(with: toadFrames, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatForever(animateAction)
        toad.run(repeatAction)
        
        // Create and run a sequence of actions that moves the cake up and down
        let moveUp = SKAction.moveBy(x: 0, y: 15, duration: 0.25)
        let moveDown = SKAction.moveBy(x: 0, y: -15, duration: 0.25)
        let wobbleGroup = SKAction.sequence([moveDown, moveUp])
        let wobbleAction = SKAction.repeatForever(wobbleGroup)
        toad.run(wobbleAction)
        
        // Create an action that moves the cake left
        let moveLeft = SKAction.moveTo(x: frame.minX - toad.size.width, duration: 5.0)
        
        // Create an action to remove the cake sprite node
        let removeFromParent = SKAction.removeFromParent()
        
        // Combine the actions into a sequence
        let moveSequence = SKAction.sequence([moveLeft, removeFromParent])
        
        // Periodically run this method using a timed range
        toad.run(moveSequence, completion: {
            let wait = SKAction.wait(forDuration: 8, withRange: 15)
            let codeBlock = SKAction.run { self.sendBrownToad() }
            self.run(SKAction.sequence([wait, codeBlock]))
        })
    }
    
    // MARK: - GAME FUNCTIONS
    /* ################################################################# */
    
    func spawnCollectible_strawberry(){
        guard isCollectibleActive else { return }
        var collectibleType: CollectibleType3 = .strawberry
        // Create a new collectible instance
        collectible = Collectible3(collectibleType3: collectibleType)
        
        // Add collectible to scene
        if let collectible = collectible {
            addChild(collectible)
            //count += 1
            print("Spawned")
            print(collectible.position)
            isCollectibleActive = true
            
        }
    }
    
    func spawnCollectible_egg(){
        guard isCollectibleActive else { return }
        var collectibleType: CollectibleType3 = .egg
        // Create a new collectible instance
        collectible = Collectible3(collectibleType3: collectibleType)
        
        // Add collectible to scene
        if let collectible = collectible {
            addChild(collectible)
            //count += 1
            print("Spawned")
            print(collectible.position)
            isCollectibleActive = true
            
        }
    }
    
    func spawnCollectible_milk(){
        guard isCollectibleActive else { return }
        var collectibleType: CollectibleType3 = .milk
        // Create a new collectible instance
        collectible = Collectible3(collectibleType3: collectibleType)
        
        // Add collectible to scene
        if let collectible = collectible {
            addChild(collectible)
            //count += 1
            print("Spawned")
            print(collectible.position)
            isCollectibleActive = true
            
        }
    }

    func spawnRequest() {
        // Check if max amount of requests was not exceeded
        if gameInProgress && requestcount < 20 {
            requestcount += 1
            let randomChef = Int.random(in: 1...3)

            switch randomChef {
            case 1:
                requestedby = "chefA"
                print("chef a request")
            case 2:
                requestedby = "chefB"
                print("chef b request")
            case 3:
                requestedby = "chefC"
                print("chef c request")
            default:
                break
            }

            let randomCollectible = Int.random(in: 1...3)

            switch randomCollectible {
            case 1:
                requestedCollectible = "milk"
                let board = SKSpriteNode(imageNamed: "board_milk")
                setupBoard(board)
                print("milk request")
            case 2:
                requestedCollectible = "egg"
                let board = SKSpriteNode(imageNamed: "board_egg")
                setupBoard(board)
                print("egg request")
            case 3:
                requestedCollectible = "strawberry"
                let board = SKSpriteNode(imageNamed: "board_strawberry")
                setupBoard(board)
                print("strawberry request")
            default:
                break
            }
        } else {
            gameOver()
        }
    }

    func setupBoard(_ board: SKSpriteNode) {
        // CHANGE POSITION BASED ON CHEF THAT REQUESTED
        board.zPosition = Layer.background.rawValue + 1
        board.position = CGPoint(x: frame.midX  , y: frame.midY)
        board.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        board.xScale = 1.5 // Increase width scale
        board.yScale = 1.5
        addChild(board)
    }

    
    func gameLogic(){
        gameInProgress = true
        spawnCollectible_strawberry()
        spawnCollectible_egg()
        spawnCollectible_milk()
        showChefA()
        showChefB()
        showChefC()
        spawnRequest()
        startTimer()
        
        //check if request was fullfilled
        if requestedby == "chefA" {
            if requestedCollectible == "milk"{
                return
            }
            else if requestedCollectible == "egg"{
                return
            }
            else if requestedCollectible == "strawberry"{
                return
            }
        } else if requestedby == "chefB" {
            if requestedCollectible == "milk"{
                return
            }
            else if requestedCollectible == "egg"{
                return
            }
            else if requestedCollectible == "strawberry"{
                return
            }
        } else if requestedby == "chefC" {
            if requestedCollectible == "milk"{
                return
            }
            else if requestedCollectible == "egg"{
                return
            }
            else if requestedCollectible == "strawberry"{
                return
            }
            
        }}
        
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
    
    //redo -->>>>
    func scoreCount(){
        if time >= 85{
            score = "A"
        } else if time >= 75{
            score = "B"
        } else if time >= 65{
            score = "C"
        } else if time >= 50{
            score = "D"
        } else if time >= 40{
            score = "E"
        } else if time <= 39{
            score = "F"
        }}
    
    
    func gameOver() {
        gameover = true
        print(score)
        showMessage("GAME OVER")
        stopTimer()
        isCollectibleActive = false
        setupBackToMainScreenButton()
        
    }
    
    // MARK: - TOUCH HANDLING
    
    // TOUCH HANDLING
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let location = touch.location(in: self)
            touchDown(atPoint: location)
            print("Touch began at: \(location)")
        }
    }

    var lastTouchTimestamp: TimeInterval?

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let currentTimeStamp = touch.timestamp
            
            if let lastTimestamp = lastTouchTimestamp {
                let dt = CGFloat(currentTimeStamp - lastTimestamp)
                touchMoved(toPoint: location, dt: dt)
            }
            
            lastTouchTimestamp = currentTimeStamp
            print("Touch moved to: \(location)")
        }
    }





    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            touchUp(atPoint: location)
            print("Touch ended at: \(location)")
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            touchUp(atPoint: location)
            print("Touch cancelled at: \(location)")
        }
    }
    
    

    
    func touchDown(atPoint pos: CGPoint) {
        let touchedNode = atPoint(pos)
        
            hideMessage() // Hide the message when the player touches the character
        if gameInProgress == false {
            gameLogic()
            return
        }
        if touchedNode.name == "player" {
            movingPlayer = true
        }
        
    }
    
    func touchMoved(toPoint pos: CGPoint, dt: CGFloat) {
        if movingPlayer {
            // Update character's position (x and y)
            player.position = CGPoint(x: pos.x, y: pos.y + verticalSpeed * dt)
            
            // Update last known position
            lastPosition = pos
        }
    }
    
    func touchUp(atPoint pos: CGPoint) {
        movingPlayer = false
    }

}
