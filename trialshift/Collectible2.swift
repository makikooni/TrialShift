//
//  Collectible2.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 04/04/2024.
//

import Foundation
import SpriteKit

enum CollectibleType2: String {
    case none
    case dark_chocolate
    case white_chocolate
}

class Collectible2: SKSpriteNode {
    // MARK: - PROPERTIES
    private var collectibleType2: CollectibleType2 = .none
    //CHANGE SOUNDS
    private let playCollectSound = SKAction.playSoundFileNamed("collect.wav", waitForCompletion: false)
    
    
    // MARK: - INIT
    init(collectibleType2: CollectibleType2) {
        var texture: SKTexture!
        self.collectibleType2 = collectibleType2
        
        
        // Set the texture based on the type
        switch self.collectibleType2 {
        case .dark_chocolate:
            texture = SKTexture(imageNamed: "dark_chocolate")
        case .white_chocolate:
            texture = SKTexture(imageNamed: "white_chocolate")
            
        case .none:
            break
        }
        // Call to super.init
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        // Set up collectible
        self.name = "co_\(collectibleType2)"
        self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        self.zPosition = Layer.collectible.rawValue
        self.position = CGPoint(x: 1255, y: 240)
    }
    
    
    // Required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
