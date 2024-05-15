//
//  StartMenuScene.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 29/03/2024.
//

import Foundation
import AVFoundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTitleLabel: SKLabelNode!
    var gameOneTopScore: SKLabelNode!
    var gameTwoTopScore: SKLabelNode!
    var gameThreeTopScore: SKLabelNode!
    var gameOneButton: SKSpriteNode!
    var gameTwoButton: SKSpriteNode!
    var gameThreeButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        self.scaleMode = .aspectFit
        
        //BACKGROUND
        let background = SKSpriteNode(imageNamed: "background_02")
        self.scaleMode = .aspectFill
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.zPosition = Layer.background.rawValue
        background.position = CGPoint(x: 0, y: 0)
        addChild(background)
        
        // TITLE LABEL 
           gameTitleLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold") // Replace with your font name
           gameTitleLabel.text = "Show me what you got!"
           gameTitleLabel.fontSize = 70.0
           gameTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 250)
           gameTitleLabel.zPosition = Layer.ui.rawValue
           addChild(gameTitleLabel)

           // Create game one button
           gameOneButton = SKSpriteNode(imageNamed: "gameOneButton") // Replace with your button image name
           gameOneButton.name = "gameOneButton" // Assign a name for identification
           gameOneButton.position = CGPoint(x: frame.midX - 600, y: frame.midY )
           gameOneButton.zPosition = Layer.ui.rawValue + 1
        gameOneButton.setScale(2.5) // Adjust scale if needed
           addChild(gameOneButton)
        
        // Top Score 1
           gameOneTopScore = SKLabelNode(fontNamed: "ChalkboardSE-Bold") // Replace with your font name
        gameOneTopScore.text = "Top: "
        gameOneTopScore.fontSize = 60.0
        gameOneTopScore.position = CGPoint(x: frame.midX - 600 , y: frame.midY - 250)
        gameOneTopScore.zPosition = Layer.ui.rawValue
           addChild(gameOneTopScore)

           // Create game two button
           gameTwoButton = SKSpriteNode(imageNamed: "gameTwoButton") // Replace with your button image name
           gameTwoButton.name = "gameTwoButton" // Assign a name for identification
           gameTwoButton.position = CGPoint(x: frame.midX , y: frame.midY )
           gameTwoButton.zPosition = Layer.ui.rawValue + 1
            gameTwoButton.setScale(2.5) // Adjust scale if needed
           addChild(gameTwoButton)
        
        // Top Score 2
           gameTwoTopScore = SKLabelNode(fontNamed: "ChalkboardSE-Bold") // Replace with your font name
        gameTwoTopScore.text = "Top: "
        gameTwoTopScore.fontSize = 60.0
        gameTwoTopScore.position = CGPoint(x: frame.midX, y: frame.midY - 250)
        gameTwoTopScore.zPosition = Layer.ui.rawValue
           addChild(gameTwoTopScore)
        
            // Create game three button
            gameThreeButton = SKSpriteNode(imageNamed: "gameThreeButton") // Replace with your button image name
            gameThreeButton.name = "gameThreeButton" // Assign a name for identification
            gameThreeButton.position = CGPoint(x: frame.midX + 600, y: frame.midY)
            gameThreeButton.zPosition = Layer.ui.rawValue + 1
            gameThreeButton.setScale(2.5) // Adjust scale if needed
            addChild(gameThreeButton)
        
        // Top Score 3
           gameThreeTopScore = SKLabelNode(fontNamed: "ChalkboardSE-Bold") // Replace with your font name
        gameThreeTopScore.text = "Top: "
        gameThreeTopScore.fontSize = 60.0
        gameThreeTopScore.position = CGPoint(x: frame.midX + 600, y: frame.midY - 250)
        gameThreeTopScore.zPosition = Layer.ui.rawValue
           addChild(gameThreeTopScore)
    }
    //Functions activating buttons 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                if gameOneButton.contains(location) {
                    // Transition to the game scene when the start button is tapped
                    let gameOne = GameOne(size: self.size)
                    gameOne.scaleMode = .aspectFill
                    self.view?.presentScene(gameOne)
                }
                if gameTwoButton.contains(location) {
                    let gameTwo = GameTwo(size: self.size)
                    gameTwo.scaleMode = .aspectFill
                    self.view?.presentScene(gameTwo)
                }
                if gameThreeButton.contains(location) {
                    let gameThree = GameThree(size: self.size)
                    gameThree.scaleMode = .aspectFill
                    self.view?.presentScene(gameThree)
                }
            }
        }
    }
