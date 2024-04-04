//
//  GameTwo.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 03/04/2024.
//

// 1. repair visibility of labels
// 2. Update assets for playerHead in player file
//3. update funcitons to allow right and left hand move only 
import AVFoundation
import SpriteKit
import GameplayKit

class GameTwo: SKScene {
    let player = PlayerHead()
    
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
    
    override func didMove(to view: SKView) {
        
        //self.scaleMode = .aspectFit
        
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
        
        // SET UP PLAYER
        player.setupConstraints(floor: frame.minY + 370)
        
        // check minY later here - >
        player.position = CGPoint(x: size.width/2, y: frame.minY + 370)
        addChild(player)
        //player.walk()
        //MESSAGE
         //showMessage("TAP TO START")
        

    }
    
    func setupLabels() {
    /* SCORE LABEL */
    scoreLabel.name = "score"
    scoreLabel.fontName = "ChalkboardSE-Bold"
    scoreLabel.fontColor = .white
    scoreLabel.fontSize = 65.0
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.verticalAlignmentMode = .center
    scoreLabel.zPosition = Layer.ui.rawValue
    scoreLabel.position = CGPoint(x: frame.maxX - 230, y: viewTop() - 120)
    
    // Set the text and add the label node to scene
    scoreLabel.text = "Score: 0"
    addChild(scoreLabel)
      
    /* LEVEL LABEL */
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
    
    
    }
