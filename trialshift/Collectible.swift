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
      }
    // Required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }
    
    // MARK: - FUNCTIONS
    func drop(dropSpeed: TimeInterval, floorLevel: CGFloat) {
        let pos = CGPoint(x: position.x, y: floorLevel)
        //Scaling the water drop during animation
        let scaleX = SKAction.scaleX(to: 0.22, duration: 1.0)
        let scaleY = SKAction.scaleY(to: 0.25, duration: 1.0)
        let scale = SKAction.group([scaleX, scaleY])
        
        let appear = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
        let moveAction = SKAction.move(to: pos, duration: dropSpeed)
        
        // Add texture change action
        let changeTexture = SKAction.run {
               if self.position.y <= (floorLevel + 50) {
                   self.texture = SKTexture(imageNamed: "water_1")
               }
           }
        
        let actionSequence = SKAction.sequence([appear, scale, moveAction,changeTexture])
        
        // Shrink first, then run fall action
        self.scale(to: CGSize(width: 0.27, height: 1.0))
        self.run(actionSequence, withKey: "drop")
        
        }}
    

