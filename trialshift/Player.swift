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
    self.anchorPoint = CGPoint(x: 0.5, y: 0.05) // center-bottom
    self.zPosition = Layer.player.rawValue
    }
    required init?(coder aDecoder: NSCoder) { 
        fatalError("init(coder:) has not been implemented")
    }
    // Textures (Animation)
    private var walkTextures: [SKTexture]?
    
    func setupConstraints(floor: CGFloat) {
        let range = SKRange(lowerLimit: floor, upperLimit: floor) 
        let lockToPlatform = SKConstraint.positionY(range)
        constraints = [ lockToPlatform ]
    }
    
    // MARK: - METHODS
    func walk() {
        // Check for textures
        guard let walkTextures = walkTextures else {
            preconditionFailure("Could not find textures!") }
        // Run animation (forever)
        startAnimation(textures: walkTextures, speed: 0.25,
                       name: PlayerAnimationType.walk.rawValue,
                       count: 0, resize: true, restore: true)
    }
    func moveToPosition(pos: CGPoint, direction: String, speed: TimeInterval) { 
        switch direction {
        case "L":
            xScale = -abs(xScale) default:
            xScale = abs(xScale) }
        let moveAction = SKAction.move(to: pos, duration: speed)
        run(moveAction) }

    }
