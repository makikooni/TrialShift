//
//  Collectible.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 08/03/2024.
//

import Foundation
import SpriteKit

// This enum lets you add different types of collectibles
enum CollectibleType: String {
    case none
    case water
}

class Collectible: SKSpriteNode {
    
    // MARK: - PROPERTIES
    private var collectibleType: CollectibleType = .none
    private let playCollectSound = SKAction.playSoundFileNamed("collect.wav", waitForCompletion: false)
    private let playMissSound = SKAction.playSoundFileNamed("miss.wav", waitForCompletion: false)
    
    // MARK: - INIT
    init(collectibleType: CollectibleType) {
        var texture: SKTexture!
        self.collectibleType = collectibleType
        
        
        // Set the texture based on the type
        switch self.collectibleType {
        case .water:
            texture = SKTexture(imageNamed: "water_0")
            
        case .none:
            break
        }
        // Call to super.init
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        // Set up collectible
        self.name = "co_\(collectibleType)"
        self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        self.zPosition = Layer.collectible.rawValue
        
        // Add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size, center: CGPoint(x: 0.0, y: -self.size.height/2))
        self.physicsBody?.affectedByGravity = false
        
        
        // Set up physics categories for contacts
        self.physicsBody?.categoryBitMask = PhysicsCategory.collectible
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        | PhysicsCategory.foreground
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        
        
    }
    // Required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    func drop(dropSpeed: TimeInterval, floorLevel: CGFloat) {
        let scaledHeight = self.size.height * 0.2 // Adjusted scale factor to match the scaleFactor in changeTexture action
        let pos = CGPoint(x: position.x, y: floorLevel - 75) // Adjusted position calculation
        let scaleX = SKAction.scaleX(to: 0.22, duration: 1.0)
        let scaleY = SKAction.scaleY(to: 0.25, duration: 1.0)
        let scale = SKAction.group([scaleX, scaleY])
        
        let appear = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
        let moveAction = SKAction.move(to: pos, duration: dropSpeed)
        
        let changeTexture = SKAction.run {
            if self.position.y <= (floorLevel + 76) {
                self.texture = SKTexture(imageNamed: "water_1")
                
                let scaleFactor: CGFloat = 0.3  // Set this to the desired percentage of the original size
                let newWidth = self.texture!.size().width * scaleFactor
                let newHeight = self.texture!.size().height * scaleFactor
                
                self.size = CGSize(width: newWidth, height: newHeight)
            }
        }
        
        let actionSequence = SKAction.sequence([appear, scale, moveAction, changeTexture])
        self.scale(to: CGSize(width: 0.27, height: 1.0))
        self.run(actionSequence, withKey: "drop")
    }
    
    
    // Handle Contacts
    func collected() {
        let removeFromParent = SKAction.removeFromParent()
        let actionGroup = SKAction.group([playCollectSound, removeFromParent])
        self.run(actionGroup)
    }
    
    func missed() {
        //stopping  physics simulation so it doesn't move anymore
        //self.physicsBody?.isDynamic = false
        
        
        // You might also want to remove its physics body if you don't want further collisions
        self.physicsBody = nil
        //let removeFromParent = SKAction.removeFromParent()
        let actionGroup = SKAction.group([playMissSound])
        self.run(actionGroup)
    }
    
}

