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
    var gameOneButton: SKSpriteNode!
    var gameTwoButton: SKSpriteNode!
    
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
           gameTitleLabel.text = "Let's begin"
           gameTitleLabel.fontSize = 70.0
           gameTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 200)
           gameTitleLabel.zPosition = Layer.ui.rawValue
           addChild(gameTitleLabel)

           // Create game one button
           gameOneButton = SKSpriteNode(imageNamed: "gameOneButton") // Replace with your button image name
           gameOneButton.name = "gameOneButton" // Assign a name for identification
           gameOneButton.position = CGPoint(x: frame.midX - 300, y: frame.midY - 50)
           gameOneButton.zPosition = Layer.ui.rawValue + 1
        gameOneButton.setScale(2.5) // Adjust scale if needed
           addChild(gameOneButton)

           // Create game two button (similar to gameOneButton)
           gameTwoButton = SKSpriteNode(imageNamed: "gameTwoButton") // Replace with your button image name
           gameTwoButton.name = "gameTwoButton" // Assign a name for identification
           gameTwoButton.position = CGPoint(x: frame.midX + 300, y: frame.midY - 50)
           gameTwoButton.zPosition = Layer.ui.rawValue + 1
        gameTwoButton.setScale(2.5) // Adjust scale if needed
           addChild(gameTwoButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                if gameOneButton.contains(location) {
                    // Transition to the game scene when the start button is tapped
                    let gameOne = GameOne(size: self.size)
                    gameOne.scaleMode = .aspectFill
                    self.view?.presentScene(gameOne)
                }
                //if gameTwoButton.contains(location) {
                    // Transition to the game scene when the start button is tapped
                    //let gameTwo = GameTwo(size: self.size)
                    //gameTwo.scaleMode = .aspectFill
                    //self.view?.presentScene(gameTwo)
                }
            }
        }
    //}
