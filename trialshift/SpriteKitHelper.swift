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
}
