//
//  FavoriteRoverItem.swift
//  Assignment2
//
//  Created by Ankitgiri Gusai on 2023-02-23.
//

import SwiftUI

struct FavoriteRoverItem: View {
    //let marsAPIImage: MarsAPIImage
    let colors: [String: Color] = ["Perseverance": .purple, "Curiocity" : .mint, "Oppertunity": .yellow]
    var body: some View {
        HStack{
            
            Image("abc")
                .resizable()
                .clipShape(Circle())
                .overlay(Circle().stroke(colors["Perseverance", default: .white], lineWidth: 2))
                .frame(width: 48, height: 48)
                .aspectRatio(contentMode: .fill)
            
            
            VStack (alignment: .leading){
                Text("id").font(.headline)
                Text("earth date")
            }
            
            Spacer()
            
            Text("Perseverance")
                .font(.caption)
                .fontWeight(.black)
                .padding(5)
                .background(colors["Perseverance", default: .white])
                .cornerRadius(5)
                .foregroundColor(.white)
        }
    }
}

struct FavoriteRoverItem_Previews: PreviewProvider {
    
    static var previews: some View {

        
        FavoriteRoverItem()
        
    }
}
