//
//  ContentView.swift
//  KBReffing
//
//  Created by Mark Miranda on 11/23/20.
//

import SwiftUI

struct ContentView: View {
    @StateObject var manager = Manager()
    
    @State private var showAddGame = false
    @State private var hasNewGame = false
    
    
    let df = DateFormatter()
    
    var body: some View {
        NavigationView {
            VStack {
                if manager.selectedGame != nil {
                    NavigationLink(destination: GameDetailScoring(game: manager.selectedGame!), isActive: $hasNewGame) {
                        EmptyView()
                    }.hidden()
                }
                List {
                    ForEach(manager.allGames) { game in
                        NavigationLink(destination: GameDetailScoring(game: game)) {
                            GameCell(game: game)
                        }
                        .accessibilityIdentifier("game\(manager.gameIndex(game))")
                        
                    }
                    .onDelete(perform: deleteGame)
                }
                .listStyle(GroupedListStyle())
            }
            .navigationTitle(Text("Games"))
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.showAddGame = true
                                    }, label: {
                                        Image(systemName: "plus")
                                    })
            )
            .sheet(isPresented: self.$showAddGame) {
                AddGame(manager: manager, hasNewGame: self.$hasNewGame)
            }
        }
        .onAppear { loadGames() }
        .environmentObject(manager)
    }
    
    func deleteGame(at offsets: IndexSet) {
        self.manager.removeGame(at: offsets)
    }
    
    func loadGames() {
        do {
            try manager.setGames()
            print("YO: \(manager.allGames)")
        } catch {
            print(error)
        }
    }
}

struct GameCell: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.formattedDate())
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Text(game.awayTeamName)
                    .font(.headline)
                Text(" vs. ").foregroundColor(.red)
                Text(game.homeTeamName)
                    .font(.headline)
            }
            .padding(.vertical, 1)
            .accessibility(identifier: "HEY")
            Text(game.stringStatus())
                .font(.subheadline)
                .foregroundColor(.blue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Manager())
    }
}
