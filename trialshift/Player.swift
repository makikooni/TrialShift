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
    case die
}

class Player: SKSpriteNode {
    // MARK: - PROPERTIES
    private var dieTextures: [SKTexture]?
    
    // MARK: - INIT
    init() {
        
        
        
        // Set default texture
        let texture = SKTexture(imageNamed: "avatar_0") // Call to super.init
        print("Texture size: \(texture.size())")

        
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        // Set up animation textures
        self.walkTextures = self.loadTextures(atlas: "Chef", prefix: "avatar_", startsAt: 0, stopsAt: 4)
        
        
        self.dieTextures = self.loadTextures(atlas: "Chef", prefix: "avatar_",
                                             startsAt: 5, stopsAt: 5)
        
        // Set up other properties after init
        self.name = "player"
        self.setScale(1.6)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.25) // center-bottom
        self.zPosition = Layer.player.rawValue
        
        // Add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: CGPoint(x: 0.0, y: self.size.height/2))
        self.physicsBody?.affectedByGravity = false
        
        
        // Set up physics categories for contacts
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.collectible
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
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
        // Stop the die animation
        removeAction(forKey: PlayerAnimationType.die.rawValue)
        
        // Run animation (forever)
        startAnimation(textures: walkTextures, speed: 0.25,
                       name: PlayerAnimationType.walk.rawValue,
                       count: 0, resize: true, restore: true)
    }
    
    func die() {
        // Check for textures
        guard let dieTextures = dieTextures else {
            preconditionFailure("Could not find textures!")
        }
        // Stop the walk animation
        removeAction(forKey: PlayerAnimationType.walk.rawValue)
        
        // Run animation (forever)
        startAnimation(textures: dieTextures, speed: 0.25,
                       name: PlayerAnimationType.die.rawValue,
                       count: 0, resize: true, restore: true)
    }
    func moveToPosition(pos: CGPoint, direction: String, speed: TimeInterval) {
        switch direction {
        case "L":
            if xScale > 0 {
                xScale *= -1 // Flip the character horizontally
            }
        default:
            if xScale < 0 {
                xScale *= -1 // Reset the character's scale to its original state
            }
        }
        let moveAction = SKAction.move(to: pos, duration: speed)
        run(moveAction)
    }
}

class PlayerHead: SKSpriteNode {
    // MARK: - PROPERTIES
    private var dieTextures: [SKTexture]?
    
    // MARK: - INIT
    init() {
        
        
        
        // Set default texture
        let texture = SKTexture(imageNamed: "avatar_0") // Call to super.init
        print("Texture size: \(texture.size())")

        
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
        // Set up animation textures
        self.walkTextures = self.loadTextures(atlas: "Chef", prefix: "avatar_", startsAt: 0, stopsAt: 4)
        
        
        self.dieTextures = self.loadTextures(atlas: "Chef", prefix: "avatar_",
                                             startsAt: 5, stopsAt: 5)
        
        // Set up other properties after init
        self.name = "player"
        self.setScale(1.6)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.25) // center-bottom
        self.zPosition = Layer.player.rawValue
        
        // Add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: CGPoint(x: 0.0, y: self.size.height/2))
        self.physicsBody?.affectedByGravity = false
        
        
        // Set up physics categories for contacts
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.collectible
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
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
        // Stop the die animation
        removeAction(forKey: PlayerAnimationType.die.rawValue)
        
        // Run animation (forever)
        startAnimation(textures: walkTextures, speed: 0.25,
                       name: PlayerAnimationType.walk.rawValue,
                       count: 0, resize: true, restore: true)
    }
    
    func die() {
        // Check for textures
        guard let dieTextures = dieTextures else {
            preconditionFailure("Could not find textures!")
        }
        // Stop the walk animation
        removeAction(forKey: PlayerAnimationType.walk.rawValue)
        
        // Run animation (forever)
        startAnimation(textures: dieTextures, speed: 0.25,
                       name: PlayerAnimationType.die.rawValue,
                       count: 0, resize: true, restore: true)
    }
    func moveToPosition(pos: CGPoint, direction: String, speed: TimeInterval) {
        switch direction {
        case "L":
            if xScale > 0 {
                xScale *= -1 // Flip the character horizontally
            }
        default:
            if xScale < 0 {
                xScale *= -1 // Reset the character's scale to its original state
            }
        }
        let moveAction = SKAction.move(to: pos, duration: speed)
        run(moveAction)
    }
}
