//
//  SpriteKitHelper.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 08/03/2024.
//

import Foundation
import SpriteKit
// MARK: - SPRITEKIT EXTENSIONS
// Set up shared z-positions
enum Layer: CGFloat { 
    case background
    case foreground
    case player
    case collectible
    case ui
}

enum PhysicsCategory {
static let none: UInt32 = 0
static let player: UInt32 = 0b1 // 1 
static let collectible: UInt32 = 0b10 // 2
static let foreground: UInt32 = 0b100 // 4
}

extension SKSpriteNode {
    
    // Used to load texture arrays for animations
    func loadTextures(atlas: String, prefix: String,
    startsAt: Int, stopsAt: Int) -> [SKTexture] {
    var textureArray = [SKTexture]()
    let textureAtlas = SKTextureAtlas(named: atlas) 
    for i in startsAt...stopsAt {
        let textureName = "\(prefix)\(i)"
        let temp = textureAtlas.textureNamed(textureName) 
        textureArray.append(temp)
    }
    return textureArray }
    
    
    // Start the animation using a name and a count (0 = repeat forever)
    func startAnimation(textures: [SKTexture], speed: Double, name: String, count: Int, resize: Bool, restore: Bool) {
      // Run animation only if animation key doesn't already exist
        if (action(forKey: name) == nil) {
            let animation = SKAction.animate(with: textures, timePerFrame: speed,
                                             resize: resize, restore: restore)
            if count == 0 {
                
                // Run animation until stopped
                let repeatAction = SKAction.repeatForever(animation)
                run(repeatAction, withKey: name)
            } else if count == 1 {
                run(animation, withKey: name)
            } else {
                let repeatAction = SKAction.repeat(animation, count: count)
                run(repeatAction, withKey: name)
            }
        }
    }
}

extension SKScene {
    
    // Top of view
    func viewTop() -> CGFloat {
        return convertPoint(fromView: CGPoint(x: 0.0, y: 0)).y
    }
    // Bottom of view
    func viewBottom() -> CGFloat {
        guard let view = view else { return 0.0 }
        return convertPoint(fromView: CGPoint(x: 0.0, y: view.bounds.size.height)).y
    }
}
