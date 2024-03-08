//
//  Player.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 08/03/2024.
//

import Foundation
import SpriteKit

enum PlayerAnimationType: String { 
    case walk
}

class Player: SKSpriteNode {
    // MARK: - PROPERTIES
    // MARK: - INIT
    init() {
      
        // Set default texture
    let texture = SKTexture(imageNamed: "avatar_0") // Call to super.init
    super.init(texture: texture, color: .clear, size: texture.size())
      
        // Set up animation textures
    self.walkTextures = self.loadTextures(atlas: "Chef", prefix: "avatar_", startsAt: 0, stopsAt: 4)
        
      // Set up other properties after init
    self.name = "player"
    self.setScale(1.0)
    self.anchorPoint = CGPoint(x: 0.5, y: 0.0) // center-bottom
    self.zPosition = Layer.player.rawValue
    }
    required init?(coder aDecoder: NSCoder) { 
        fatalError("init(coder:) has not been implemented")
    }
    // Textures (Animation)
    private var walkTextures: [SKTexture]?
    
    }
