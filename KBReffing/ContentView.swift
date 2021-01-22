//
//  ContentView.swift
//  KBReffing
//
//  Created by Mark Miranda on 11/23/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: Manager
    
    @State private var showAddGame = false
    @State private var hasNewGame = false
    
    let df = DateFormatter()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: BlankView(), isActive: $hasNewGame) {
                    EmptyView()
                }.hidden()
                
                if (manager.allGames.isEmpty) {
                    Text("There are no games.")
                        .accessibilityIdentifier("noGames")
                } else {
                    List {
//                        ForEach(manager.allGames) { game in
                        ForEach(0..<manager.allGames.count) { index in
                            let game = manager.allGames[index]
                            
                            NavigationLink(destination: BlankView()) {
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
                            .accessibilityIdentifier("game\(index)")
                            
                        }
                        .onDelete(perform: deleteGame)
                    }
                    .listStyle(GroupedListStyle())
                    .accessibility(identifier: "gameList")
                }
                
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
                AddGame(hasNewGame: self.$hasNewGame)
                    .environmentObject(self.manager)
            }
            
        }.onAppear { loadGames() }
    }
    
    func addGame() {
        print("howdy")
    }
    
    func deleteGame(at offsets: IndexSet) {
        manager.removeGame(at: offsets)
    }
    
    func loadGames() {
        do {
            try manager.setGames()
            print(manager.allGames)
        } catch {
            print(error)
        }
    }
}

struct BlankView: View {
    var body: some View {
        Text("hello")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Manager())
    }
}
