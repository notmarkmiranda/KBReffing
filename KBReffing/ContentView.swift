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
    
    
    let df = DateFormatter()
    
    var body: some View {
        NavigationView {
            VStack {
                if (manager.games.isEmpty) {
                    Text("There are no games.")
                } else {
                    List {
                        ForEach(0 ..< manager.games.count) { index in
                            VStack(alignment: .leading) {
                                Text(manager.games[index].formattedDate())
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("\(manager.games[index].awayTeamName) vs. \(manager.games[index].homeTeamName)")
                                    .font(.headline)
                                Text(manager.games[index].stringStatus())
                                    .font(.subheadline)
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Games"))
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.showAddGame = true
                                    }, label: {
                                        Image(systemName: "plus")
                                    })
            )
            .sheet(isPresented: self.$showAddGame) {
                AddGame()
                    .environmentObject(self.manager)
            }
        }
    }
    
    func addGame() {
        print("howdy")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Manager())
    }
}
