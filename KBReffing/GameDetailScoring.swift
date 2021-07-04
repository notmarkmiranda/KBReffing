//
//  GameDetailScoring.swift
//  KBReffing
//
//  Created by Mark Miranda on 1/26/21.
//

import SwiftUI

struct GameDetailScoring: View {
    @EnvironmentObject var manager: Manager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var game: Game
    
    @State private var showEditStats = false
    
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
                        }.padding(.bottom)
                        Button(action: {
                            self.showEditStats = true
                        }, label: {
                            Text("Edit Stats")
                        })
                        .accessibility(identifier: "editStatsButton")
                        
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
                        StatButton(label: "undo", disabled: disableUndo(), callback: onClick)
                            .frame(maxWidth: geometry.size.width * 0.45, maxHeight: .infinity)
                        StatButton(label: "redo", disabled: disableRedo(), callback: onClick)
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
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                ) {
                    Text("BACK")
                }
                .accessibility(identifier: "backButton")
            )
            .padding()
            .sheet(isPresented: self.$showEditStats) {
                EditStats(showEditStats: $showEditStats)
            }
        }.onAppear { setSelectedGameAndStats() }
    }
    
    private func onClick(_ stat: String) -> Void {
        manager.buttonClick(stat)
    }
    
    private func setSelectedGameAndStats() -> Void {
        manager.selectedGame = game
        let startingStats = ["inning": 1, "topOrBottom": 0, "strikes": 0, "fouls": 0, "balls": 0, "outs": 0, "awayScore": 0, "homeScore": 0]
        let stats = game.currentStats ?? startingStats
        manager.statState = [stats]
    }
    
    private func disableUndo() -> Bool {
        return manager.disableUndo()
    }
    
    private func disableRedo() -> Bool {
        return manager.disableRedo()
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
    var disabled: Bool = false
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
        .disabled(disabled)
    }
}

struct GameDetailScoring_Previews: PreviewProvider {
    @State static var manager = Manager()
    
    static var previews: some View {
        GameDetailScoring(game: Game.example).environmentObject(manager)
    }
}
