//
//  ImageDetailView.swift
//  Assignment2
//
//  Created by Ankitgiri Gusai on 2023-02-22.
//

import SwiftUI

struct ImageDetailView: View {
    let image:MarsImage
    var body: some View {
        VStack{
            //Text("\(image.id)").font(.title3)
            let imageUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(image.id).jpg")
           
            Image(uiImage: (UIImage(contentsOfFile: imageUrl.path) ?? UIImage(named: "abc"))!)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            HStack{
                Text("Rover: ")
                Text(image.rover!).fontWeight(.black)
            }
            HStack{
                Text("Cam: ")
                Text(image.camera!).fontWeight(.black)
            }
            HStack{
                Text("Earth date: ")
                Text(image.date!).fontWeight(.black)
            }
            
            
            Spacer()
        }
        .navigationTitle("\(image.id)")
            
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        //ImageDetailView()
        Text("abv")
    }
}
