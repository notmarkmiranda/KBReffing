//
//  Game.swift
//  KBReffing
//
//  Created by Mark Miranda on 11/23/20.
//

import Foundation

struct Game {
    var id: UUID
    var date: Date
    var awayTeamName: String
    var homeTeamName: String
    var status: GameStatus = GameStatus.notStarted
    
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
    static let example = Game(id: UUID(), date: Date(), awayTeamName: "The Dinosaurs", homeTeamName: "Lot Lizards", status: GameStatus.inProgress)
    static let examples = [
        Game(id: UUID(), date: Date(), awayTeamName: "The Dinosaurs", homeTeamName: "Lot Lizards", status: GameStatus.notStarted),
        Game(id: UUID(), date: Date(), awayTeamName: "Stu Gotz", homeTeamName: "The Poops", status: GameStatus.finished)
    ]
    #endif
}

enum GameStatus {
    case notStarted, inProgress, finished
}
