//
//  GameDetailScoring.swift
//  KBReffing
//
//  Created by Mark Miranda on 1/26/21.
//

import SwiftUI

struct GameDetailScoring: View {
    @State var game: Game!  
    
    var body: some View {
        HStack {
            Text(game.awayTeamName)
                .accessibility(identifier: "awayTeamName")
            Text("vs.")
            Text(game.homeTeamName)
                .accessibility(identifier: "homeTeamName")
        }
    }
}

struct GameDetailScoring_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailScoring(game: Game.example)
    }
}
