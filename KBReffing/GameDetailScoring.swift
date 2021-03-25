//
//  GameDetailScoring.swift
//  KBReffing
//
//  Created by Mark Miranda on 1/26/21.
//

import SwiftUI

struct GameDetailScoring: View {
    @ObservedObject var manager: Manager
    @State var game: Game
    
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
                        Text("\(manager.findStat("awayScore"))")
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
                        Text("\(manager.findStat("homeScore"))")
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
                            CountRow(countLabel: "Balls", countStat: manager.findStat("balls"), identifier: "ball")
                            if game.combineStrikesFouls() {
                                CountRow(countLabel: "Strikes & Fouls", countStat: (manager.findStat("strikes") + manager.findStat("fouls")), identifier: "strikeFoul")
                            } else {
                                CountRow(countLabel: "Strikes", countStat: 2, identifier: "strike")
                                CountRow(countLabel: "Fouls", countStat: 3, identifier: "foul")
                            }
                            CountRow(countLabel: "Outs", countStat: manager.findStat("outs"), identifier: "out")
                        }
                    }
                    .frame(minWidth: 0, maxWidth: geometry.size.width * 0.7)
                    
                    VStack {
                        Text("Inning")
                            .bold()
                        HStack {
                            Image(systemName: game.halfInning(manager.findStat("topOrBottom")))
                                .accessibility(identifier: "halfInningStat")
                            Text(String(manager.findStat("inning"))).font(.largeTitle)
                                .accessibility(identifier: "inningStat")
                        
                        }
                    }
                    .frame(minWidth: 0, maxWidth: geometry.size.width * 0.3)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                Divider()
                HStack {
                    VStack {
                        StatButton(label: "out", callback: onClick)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "foul", callback: onClick)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "ball", callback: onClick)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "strike", callback: onClick)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                    VStack {
                        StatButton(label: "undo", callback: onClick)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "redo", callback: onClick)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "run", callback: onClick)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "safe", callback: onClick)
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
        }.onAppear { setSelectedGameAndStats() }
    }
    
    private func onClick(_ stat: String) -> Void {
        manager.buttonClick(stat)
    }
    
    private func setSelectedGameAndStats() -> Void {
        if manager.selectedGame == nil {
            manager.selectedGame = game
        }
        if let stats = game.currentStats {
            manager.statState = [stats]
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
    @State static var manager = Manager()
    
    static var previews: some View {
        GameDetailScoring(manager: manager, game: Game.example)
    }
}
