//
//  Game.swift
//  KBReffing
//
//  Created by Mark Miranda on 11/23/20.
//

import Foundation

struct Game: Identifiable, Codable, Equatable {
    var id: UUID
    var date: Date
    var awayTeamName: String
    var homeTeamName: String
    var status: GameStatus = GameStatus.notStarted
    var numbersDictionary: [String: Int]
    var booleanDictionary: [String: Bool]
    var currentStats: [String: Int]?
    
    var stateArray: [[String: Int]] = []
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }
    
    func combineStrikesFouls() -> Bool {
        return booleanDictionary["combineStrikesFouls"] == true
    }
    
    func formattedDate() -> String {
        let df = DateFormatter()
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
    
    func numberOfInnings() -> Int {
        if let innings = numbersDictionary["numberOfInnings"] {
            return innings
        } else {
            return 99
        }
    }
    
    func halfInning(_ topOrBottom: Int) -> String {
        topOrBottom % 2 == 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill"
    }
    
    #if DEBUG
    static let example = Game(id: UUID(), date: Date(), awayTeamName: "The Dinosaurs", homeTeamName: "Lot Lizards", status: GameStatus.inProgress, numbersDictionary: ["numberOfInnings": 5, "outsPerInning": 3, "strikesFoulsPerOut": 5, "strikesPerOut": 3, "foulsPerOut": 4, "ballsPerWalk": 4], booleanDictionary: ["combineStrikesFouls": true, "canFoulOut": true])
    static let examples = [
        Game(id: UUID(), date: Date(), awayTeamName: "The Dinosaurs", homeTeamName: "Lot Lizards", status: GameStatus.notStarted, numbersDictionary: ["numberOfInnings": 5, "outsPerInning": 3, "strikesFoulsPerOut": 5, "strikesPerOut": 3, "foulsPerOut": 4, "ballsPerWalk": 4], booleanDictionary: ["combineStrikesFouls": true, "canFoulOut": true]),
        Game(id: UUID(), date: Date(), awayTeamName: "Stu Gotz", homeTeamName: "The Poops", status: GameStatus.finished, numbersDictionary: ["numberOfInnings": 5, "outsPerInning": 3, "strikesFoulsPerOut": 5, "strikesPerOut": 3, "foulsPerOut": 4, "ballsPerWalk": 4], booleanDictionary: ["combineStrikesFouls": true, "canFoulOut": true])
    ]
    #endif
}

enum GameStatus: String, Codable {
    case notStarted, inProgress, finished
}
