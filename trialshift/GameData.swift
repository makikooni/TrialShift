//
//  GameData.swift
//  trialshift
//
//  Created by Weronika E. Falinska on 27/05/2024.
//

import Foundation

class GameData {
    static let shared = GameData()

    var scoreGameOne: String = ""
    var scoreGameTwo: String = ""
    var scoreGameThree: String = ""
    
    private init() {}
}
