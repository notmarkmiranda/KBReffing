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
        VStack(alignment: .leading) {
            Text(game.formattedDate())
                .fontWeight(.light)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            HStack(alignment: .top) {
                VStack {
                    Text(game.awayTeamName.uppercased())
                        .bold()
                        .accessibility(identifier: "awayTeamName")
                        .padding(.bottom, 10)
                    Text("9").font(.largeTitle).fontWeight(.black)
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
                    Text("2").font(.largeTitle).fontWeight(.black)
                }
                .padding(.horizontal, 2)
                .frame(maxWidth: .infinity)
                
            }
            .padding(.top, 4)
            
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

struct GameDetailScoring_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailScoring(game: Game.example)
    }
}
