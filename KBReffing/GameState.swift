//
//  GameState.swift
//  KBReffing
//
//  Created by Mark Miranda on 1/29/21.
//

import Foundation

class GameState: Codable {
    var inning: Int = 1
    var topOrBottom = inningState.top
    var strikes: Int = 0
    var fouls: Int = 0
    var balls: Int = 0
    var outs: Int = 0
    var awayScore: Int = 0
    var homeScore: Int = 0
}

enum inningState: String, Codable {
    case top, bottom
}
