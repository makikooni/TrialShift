//
//  GameScene.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 07/03/2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
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
        let player = Player()
        player.position = CGPoint(x: size.width/2, y: foreground.frame.maxY)
        addChild(player)
        
        
    }
}

