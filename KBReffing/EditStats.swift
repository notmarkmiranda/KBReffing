//
//  EditStats.swift
//  KBReffing
//
//  Created by Mark Miranda on 4/13/21.
//

import SwiftUI

struct EditStats: View {
    @EnvironmentObject var manager: Manager
    @Binding var showEditStats: Bool
    
    @State private var inning          = 1
    @State private var topOrBottom     = 0
    @State private var strikes         = 0
    @State private var fouls           = 0
    @State private var balls           = 0
    @State private var outs            = 0
    @State private var awayScore       = 0
    @State private var homeScore       = 0
    
    var body: some View {
        Form {
            Section(header: Text("Current Stats")) {
                Stepper(value: $topOrBottom, in: 0...99) {
                    Text("Top or Bottom: \(topOrBottom % 2 == 0 ? "Top" : "Bottom")")
                }
                Stepper(value: $inning, in: 1...99) {
                    Text("Current inning: \(inning)")
                }
                .accessibility(identifier: "inningStepper")
                if combineStrikesAndFouls() {
                    Stepper(value: $strikes, in: 1...maxStrikesAndFouls()) {
                        Text("Strikes & Fouls: \(strikes)")
                    }
                    .accessibility(identifier: "strikeAndFoulStepper")
                } else {
                    Stepper(value: $strikes, in: 1...maxStrikes()) {
                        Text("Strikes: \(strikes)")
                    }
                    .accessibility(identifier: "strikeStepper")
                    Stepper(value: $fouls, in: 1...maxFouls()) {
                        Text("Fouls: \(fouls)")
                    }
                }
                Stepper(value: $outs, in: 1...maxOuts()) {
                    Text("Outs: \(outs)")
                }
                Stepper(value: $awayScore, in: 0...99) {
                    Text("Away Score: \(awayScore)")
                }
                Stepper(value: $homeScore, in: 0...99) {
                    Text("Home Score: \(homeScore)")
                }
            }
            Button(action: {
                buildAndUpdateStats()
                self.showEditStats = false
            }, label: {
                Text("Save Stats")
            })
            .accessibility(identifier: "saveStatsButton")
        }
        .onAppear { setInitialStatValues() }
    }
    
    private func setInitialStatValues() {
        let statsCopy = manager.currentStats
        
        inning  = statsCopy["inning", default: 1]
        topOrBottom = statsCopy["topOrBottom", default: 0]
        strikes = statsCopy["strikes", default: 0]
        fouls = statsCopy["fouls", default: 0]
        balls = statsCopy["balls", default: 0]
        outs = statsCopy["outs", default: 0]
        awayScore = statsCopy["awayScore", default: 0]
        homeScore = statsCopy["homeScore", default: 0]
    }
    
    private func buildAndUpdateStats() -> Void {
        var newStats = manager.currentStats
        newStats["inning"] = inning
        newStats["topOrBottom"] = topOrBottom
        newStats["strikes"] = strikes
        newStats["outs"] = outs
        newStats["awayScore"] = awayScore
        newStats["homeScore"] = homeScore
        manager.setStats(newStats)
        manager.saveGame()
    }
    
    private func combineStrikesAndFouls() -> Bool {
        if let combined = manager.selectedGame?.booleanDictionary["combineStrikesFouls"] {
            return combined
        }
        return true
    }
    
    private func maxStrikesAndFouls() -> Int {
        return maxStat(stat: "strikesFoulsPerOut")
    }
    
    private func maxStrikes() -> Int {
        return maxStat(stat: "strikesPerOut")
    }
    
    private func maxFouls() -> Int {
        return maxStat(stat: "foulsPerOut")
    }
    
    private func maxOuts() -> Int {
        return maxStat(stat: "outsPerInning")
    }
    
    private func maxStat(stat: String) -> Int {
        guard let game = manager.selectedGame else { return 0 }
        
        // subtracting one so we don't need to increment an out or inning based on an edit
        return game.numbersDictionary[stat]! - 1
    }
}

struct EditStats_Previews: PreviewProvider {
    static let manager = Manager()
    
    static var previews: some View {
        EditStats(showEditStats: .constant(true)).environmentObject(manager)
    }
}
