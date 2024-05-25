//
//  Collectible3.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 10/05/2024.
//

import Foundation
import SpriteKit

enum CollectibleType3: String {
    case none
    case strawberry
    case egg
    case milk
}


class Collectible3: SKSpriteNode {
    // MARK: - PROPERTIES
    private(set) var collectibleType3: CollectibleType3 = .none
    
    
    // MARK: - INIT
    init(collectibleType3: CollectibleType3) {
        var texture: SKTexture!
        var size: CGSize!
        
        self.collectibleType3 = collectibleType3
        
        // Set the texture and size based on the type
        switch self.collectibleType3 {
        case .strawberry:
            texture = SKTexture(imageNamed: "strawberry")
            size = CGSize(width: 60, height: 60) 
            
        case .egg:
            texture = SKTexture(imageNamed: "egg")
            size = CGSize(width: 60, height: 60)
            
        case .milk:
            texture = SKTexture(imageNamed: "milk")
            size = CGSize(width: 80, height: 120)
            
        case .none:
            break
        }
        
        
        super.init(texture: texture, color: SKColor.clear, size: size)
        
        
        // Set up collectible
        self.name = "co_\(collectibleType3)"
        self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        self.zPosition = Layer.collectible.rawValue
        
        // Set position based on the type
        switch self.collectibleType3 {
        case .strawberry:
            self.position = CGPoint(x: 1900, y: 860)
        case .egg:
            self.position = CGPoint(x: 840, y: 850)
        case .milk:
            self.position = CGPoint(x: 1470, y: 910)
        case .none:
            self.position = CGPoint.zero 
        }
    }
    
    
    // Required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCollectibleType() -> CollectibleType3 {
        return collectibleType3
    }
    
    
    
}

