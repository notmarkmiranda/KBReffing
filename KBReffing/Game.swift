//
//  Game.swift
//  KBReffing
//
//  Created by Mark Miranda on 11/23/20.
//

import Foundation

struct Game: Identifiable {
    var id: UUID
    var date: Date
    var awayTeamName: String
    var homeTeamName: String
    var status: GameStatus = GameStatus.notStarted
    var numbersDictionary: [String: Int]
    var booleanDictionary: [String: Bool]
    
    let df = DateFormatter()
    
    func formattedDate() -> String {
        df.dateStyle = .medium
        return df.string(from: self.date)
    }
    
    func stringStatus() -> String {
        switch self.status {
        case GameStatus.notStarted:
            return "Not Started"
        case GameStatus.inProgress:
            return "In Progress"
        case GameStatus.finished:
            return "Finished"
        }
    }
    
    #if DEBUG
    static let example = Game(id: UUID(), date: Date(), awayTeamName: "The Dinosaurs", homeTeamName: "Lot Lizards", status: GameStatus.inProgress, numbersDictionary: ["outsPerInning": 3, "strikesFoulsPerOut": 5, "strikesPerOut": 3, "foulsPerOut": 4, "ballsPerWalk": 4], booleanDictionary: ["combineStrikesFouls": true, "canFoulOut": true])
    static let examples = [
        Game(id: UUID(), date: Date(), awayTeamName: "The Dinosaurs", homeTeamName: "Lot Lizards", status: GameStatus.notStarted, numbersDictionary: ["outsPerInning": 3, "strikesFoulsPerOut": 5, "strikesPerOut": 3, "foulsPerOut": 4, "ballsPerWalk": 4], booleanDictionary: ["combineStrikesFouls": true, "canFoulOut": true]),
        Game(id: UUID(), date: Date(), awayTeamName: "Stu Gotz", homeTeamName: "The Poops", status: GameStatus.finished, numbersDictionary: ["outsPerInning": 3, "strikesFoulsPerOut": 5, "strikesPerOut": 3, "foulsPerOut": 4, "ballsPerWalk": 4], booleanDictionary: ["combineStrikesFouls": true, "canFoulOut": true])
    ]
    #endif
}

enum GameStatus {
    case notStarted, inProgress, finished
}
