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
                Stepper(value: $inning, in: 1...9) {
                    Text("Current inning: \(inning)")
                }
                .accessibility(identifier: "inningStepper")
                if combineStrikesAndFouls() {
                    Stepper(value: $strikes, in: 1...3) {
                        Text("Number of Strikes & Fouls: \(strikes)")
                    }
                    .accessibility(identifier: "strikeAndFoulStepper")
                } else {
                    Stepper(value: $strikes, in: 1...3) {
                        Text("Number of Strikes: \(strikes)")
                    }
                    .accessibility(identifier: "strikeStepper")
                    Stepper(value: $fouls, in: 1...10) {
                        Text("Number of Fouls: \(fouls)")
                    }
                }
                Stepper(value: $outs, in: 1...3) {
                    Text("Number of Outs: \(outs)")
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
}

struct EditStats_Previews: PreviewProvider {
    static let manager = Manager()
    
    static var previews: some View {
        EditStats(showEditStats: .constant(true)).environmentObject(manager)
    }
}
