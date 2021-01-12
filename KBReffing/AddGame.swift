//
//  AddGame.swift
//  KBReffing
//
//  Created by Mark Miranda on 11/23/20.
//

import SwiftUI

struct AddGame: View {
    @State private var gameDate: Date = Date()
    @State private var awayTeam: String = ""
    @State private var homeTeam: String = ""
    @State private var outsPerInning: Int = 3
    @State private var combineStrikesFouls: Bool = true
    @State private var strikesFoulsPerOut: Int = 5
    @State private var strikesPerOut: Int = 3
    @State private var canFoulOut: Bool = true
    @State private var foulsPerOut: Int = 4
    @State private var ballsPerWalk: Int = 4
    
    @EnvironmentObject var manager: Manager
    @Environment(\.presentationMode) var presentationMode
    
    @Binding private var hasNewGame: Bool

    private func buildGame() -> Game {
        Game(id: UUID(), date: gameDate, awayTeamName: awayTeam, homeTeamName: homeTeam)
    }
    
    init(hasNewGame: Binding<Bool>) {
        _hasNewGame = hasNewGame
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Date of game")) {
                        DatePicker("Game date", selection: $gameDate, displayedComponents: .date)
                    }
                    
                    Section(header: Text("Teams")) {
                        TextField("Away Team", text: $awayTeam)
                        TextField("Home Team", text: $homeTeam)
                    }
                    
                    Section(header: Text("Game Deets")) {
                        Stepper(value: $outsPerInning, in: 1...6) {
                            Text("Outs per inning: \(outsPerInning)")
                        }
                        Toggle(isOn: $combineStrikesFouls.animation()) {
                            Text("Combine strikes & fouls")
                        }
                        if combineStrikesFouls {
                            Stepper(value: $strikesFoulsPerOut, in: 1...10) {
                                Text("Strikes & Fouls per out: \(strikesFoulsPerOut)")
                            }
                        } else {
                            Stepper(value: $strikesPerOut, in: 1...6) {
                                Text("Strikes per out: \(strikesPerOut)")
                            }
                            Toggle(isOn: $canFoulOut.animation()) {
                                Text("Foul out")
                            }
                            if canFoulOut {
                                Stepper(value: $foulsPerOut, in: 1...6) {
                                    Text("Fouls per out: \(foulsPerOut)")
                                }
                            }
                        }
                        Stepper(value: $ballsPerWalk, in: 1...6) {
                            Text("Balls per walk: \(ballsPerWalk)")
                        }
                        
                    }
                    
                }
            }
            .navigationBarTitle(Text("New Game"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    }),
                trailing:
                    Button(action: {
                        let game = buildGame()
                        self.manager.allGames.append(game)
                        self.hasNewGame = true
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Go")
                    })
            )
        }
    }
}

struct AddGame_Previews: PreviewProvider {
    @State static var value = false
    static var previews: some View {
        AddGame(hasNewGame: $value)
    }
}
