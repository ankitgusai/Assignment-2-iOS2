//
//  FavoriteImagesView.swift
//  Assignment2
//
//  Created by Ankitgiri Gusai on 2023-02-22.
//

import SwiftUI

struct FavoriteImagesView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var marsAPIImages: FetchedResults<MarsImage>
    let colors: [String: Color] = ["All": .teal, "Spirit": .purple, "Curiosity" : .mint, "Opportunity": .yellow]
    @State private var isShowingDetailView = false
    @State private var isAbc = true
    
    @State private var selectedFilter:String = "All"
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                NavigationLink(destination: SelectImageView(), isActive: $isShowingDetailView) {
                    EmptyView()
                }
                .navigationTitle("Favorite Photos")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    trailing:
                        Button("+") {
                            self.isShowingDetailView = true
                        }
                        .padding()
                        .font(.title)
                )
                
                Divider().padding()
                
                ScrollView(.horizontal){
                    
                    HStack {
                        ForEach(colors.keys.sorted(), id: \.self) { key in
                            Button(action: {
                                selectedFilter = key
                            }) {
                                Text("\(key)")
                                    .foregroundColor(selectedFilter == key ? .white: .black)
                                    .padding()
                                    .background(selectedFilter == key ? colors[key] : .clear)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20.0).stroke(lineWidth: 1.0).foregroundColor(selectedFilter == key ? .clear : .blue)
                                    )
                                
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: 60)
                        }
                        
                    }
                }
                
                Divider().padding()
                VStack {
                    FilteredList(filterRover: selectedFilter)
                    
                }
            }
        }
    }
}

struct FavoriteImagesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteImagesView()
    }
}
