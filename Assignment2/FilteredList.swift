//
//  FilteredList.swift
//  Assignment2
//
//  Created by Ankitgiri Gusai on 2023-02-25.
//

import SwiftUI

struct FilteredList: View {
    let colors: [String: Color] = ["All": .teal, "Spirit": .purple, "Curiosity" : .mint, "Opportunity": .yellow]
    @FetchRequest(sortDescriptors: []) var fetchRequest: FetchedResults<MarsImage>
    
    var body: some View {
        List(fetchRequest){ image in
            NavigationLink(destination: ImageDetailView(image: image)){
                HStack{
                    
                    let imageUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(image.id).jpg")
                    
                    Image(uiImage: (UIImage(contentsOfFile: imageUrl.path) ?? UIImage(named: "abc"))!)
                        .resizable()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(colors[image.rover!, default: .white], lineWidth: 2))
                        .frame(width: 48, height: 48)
                        .aspectRatio(contentMode: .fill)
                    
                    
                    VStack (alignment: .leading){
                        Text("\(image.id)").font(.headline)
                        Text(image.date!).font(.caption2)
                    }
                    
                    Spacer()
                    
                    Text(image.rover!)
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(5)
                        .background(colors[image.rover!, default: .white])
                        .cornerRadius(5)
                        .foregroundColor(.white)
                }
            }
        }
        
    }
    
    init(filterRover: String) {
        var setOfValues: Set<String> = []
        if(filterRover == "All"){
            setOfValues.insert("Spirit")
            setOfValues.insert("Curiosity")
            setOfValues.insert("Opportunity")
        }else{
            setOfValues.insert(filterRover)
        }
        
        _fetchRequest = FetchRequest<MarsImage>(sortDescriptors: [], predicate: NSPredicate(format: "rover IN %@", setOfValues))
    }
}

