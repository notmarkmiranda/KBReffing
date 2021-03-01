//
//  GameDetailScoring.swift
//  KBReffing
//
//  Created by Mark Miranda on 1/26/21.
//

import SwiftUI

struct GameDetailScoring: View {
    @State var game: Game
    @State var currentStats: [String: Int]
    
    func incrementStat(_ stat: String) -> Void {
        let conversion = ["out": "outs", "strike": "strikes", "foul": "fouls", "ball": "balls", "safe": "safe", "run": "run"]
        guard let stat = conversion[stat] else { return }
        if (stat == "fouls" || stat == "strikes") && game.combineStrikesFouls() == true {
            if (currentStats["fouls"]! + currentStats["strikes"]! + 1) == game.numbersDictionary["strikesFoulsPerOut"]! {
                addOut()
            } else {
                currentStats[stat]!  += 1
            }
        } else if stat == "balls" {
            if currentStats["balls"]! + 1 == game.numbersDictionary["ballsPerWalk"]! {
                currentStats["fouls"] = 0
                currentStats["strikes"] = 0
                currentStats["balls"] = 0
            } else {
                currentStats[stat]! += 1
            }
        } else if stat == "outs" {
            addOut()
        } else if stat == "safe" {
            resetFoulsStrikesBalls()
        } else if stat == "run" {
            if let topOrBottom = currentStats["topOrBottom"] {
                let halfInning = topOrBottom % 2 == 0 ? "awayScore" : "homeScore"
                scoreRun(halfInning)
                resetFoulsStrikesBalls()
                // THIS IS WHERE YOU STOPPED
            }
        } else {
            currentStats[stat]! += 1
        }
    }
    
    private func scoreRun(_ team: String) -> Void {
        currentStats[team]! += 1
    }
    
    private func addOut() -> Void {
        resetFoulsStrikesBalls()
        
        if (currentStats["outs"]! + 1) == game.numbersDictionary["outsPerInning"]! {
            if currentStats["topOrBottom"]! % 2 == 0 {
                currentStats["topOrBottom"]! += 1
            } else {
                currentStats["topOrBottom"]! += 1
                currentStats["inning"]! += 1
            }
            currentStats["outs"]! = 0
        } else {
            currentStats["outs"]! += 1
        }
    }
    
    private func resetFoulsStrikesBalls() -> Void {
        currentStats["fouls"] = 0
        currentStats["strikes"] = 0
        currentStats["balls"] = 0
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text(game.formattedDate())
                    .font(.footnote)
                    .foregroundColor(.blue)
                HStack(alignment: .top) {
                    
                    VStack {
                        Text(game.awayTeamName.uppercased())
                            .bold()
                            .accessibility(identifier: "awayTeamName")
                            .padding(.bottom, 10)
                        Text("\(currentStats["awayScore"]!)")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .accessibility(identifier: "awayTeamScore")
                    }
                    .padding(.horizontal, 2)
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("vs.")
                    }
                    
                    VStack {
                        Text(game.homeTeamName.uppercased())
                            .bold()
                            .accessibility(identifier: "homeTeamName")
                            .padding(.bottom, 10)
                        Text("\(currentStats["homeScore"]!)")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .accessibility(identifier: "homeTeamScore")
                    }
                    .padding(.horizontal, 2)
                    .frame(maxWidth: .infinity)
                    
                }
                .padding(.top, 4)
                
                Divider()
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            CountRow(countLabel: "Balls", countStat: currentStats["balls"] ?? 0, identifier: "ball")
                            if game.combineStrikesFouls() {
                                CountRow(countLabel: "Strikes & Fouls", countStat: (currentStats["strikes"]! + currentStats["fouls"]!), identifier: "strikeFoul")
                            } else {
                                CountRow(countLabel: "Strikes", countStat: 2, identifier: "strike")
                                CountRow(countLabel: "Fouls", countStat: 3, identifier: "foul")
                            }
                            CountRow(countLabel: "Outs", countStat: currentStats["outs"]!, identifier: "out")
                        }
                    }
                    .frame(minWidth: 0, maxWidth: geometry.size.width * 0.7)
                    
                    VStack {
                        Text("Inning")
                            .bold()
                        HStack {
                            Image(systemName: game.halfInning(currentStats["topOrBottom"] ?? 0))
                                .accessibility(identifier: "halfInningStat")
                            Text(String(currentStats["inning"]!)).font(.largeTitle)
                                .accessibility(identifier: "inningStat")
                        
                        }
                    }
                    .frame(minWidth: 0, maxWidth: geometry.size.width * 0.3)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                Divider()
                HStack {
                    VStack {
                        StatButton(label: "out", callback: incrementStat)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "foul", callback: incrementStat)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "ball", callback: incrementStat)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "strike", callback: incrementStat)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                    VStack {
                        StatButton(label: "UNDO", callback: incrementStat)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "REDO", callback: incrementStat)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "run", callback: incrementStat)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "safe", callback: incrementStat)
                            .frame(minWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                Spacer()
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .navigationBarTitle("", displayMode: .inline)
            .padding()
        }
    }
}

struct CountRow: View {
    let countLabel: String
    var countStat: Int
    let identifier: String
    
    var body: some View {
        HStack {
            Text(countLabel)
                .accessibility(identifier: "\(identifier)Label")
            Spacer()
            Text("\(countStat)")
                .accessibility(identifier: "\(identifier)Stat")
        }
    }
}

struct StatButton: View {
    let label: String
    let callback: (String) -> Void
    
    var body: some View {
        Button(action: {
            callback(label)
        }, label: {
            Text(label.uppercased())
        })
        .accessibility(identifier: "\(label)Button")
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .padding()
        .background(Color.accentColor)
        .cornerRadius(8)
    }
}

struct GameDetailScoring_Previews: PreviewProvider {
    
    static var previews: some View {
        GameDetailScoring(game: Game.example, currentStats: ["inning": 1, "topOrBottom": 0, "strikes": 0, "fouls": 0, "balls": 0, "outs": 0, "awayScore": 0, "homeScore": 0])
    }
}
