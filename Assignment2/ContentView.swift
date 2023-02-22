//
//  ContentView.swift
//  Assignment1
//
//  Created by Ankitgiri Gusai on 2023-02-05.
//

import SwiftUI

struct ContentView: View {
    let rovers = [
        Rover(name: "Curiosity"),
        Rover(name: "Opportunity"),
        Rover(name: "Spirit")
    ]
    @State var selectedImage = ""
    @State var selectedRover = "Curiosity"

    @State private var date = Date()
    @State private var imagesByDate = [RoverImage]()
    private let apikey = "vWd12qb1VeuciCNy5SoKcPeovpFWmtnKIX16zEsH"
    
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Mars Rovers Image Viewer").font(.title)
            
            Divider().padding()
            
            Text("Select a Rover").frame(maxWidth: .infinity, alignment: .leading)
            
            Picker("Select a Rover", selection: $selectedRover){
                ForEach(rovers, id: \.name) { rover in
                    Text(rover.name)
                }
            }.pickerStyle(.segmented)
            
            Divider().padding()
           
            DatePicker("Pick a date", selection: $date, in: ...Date(), displayedComponents: [.date])
            
            Divider().padding()
            
            HStack {
                
                if(imagesByDate.count > 0){
                    Text("Select Image")
                }
                
                Spacer()
                Picker("Pick an image", selection: $selectedImage){
                    ForEach(imagesByDate, id: \.img_src) { image in
                        Text("\(image.id) (\(image.camera.name) cam)")
                    }
                }
                .padding()
                .task(id: date) {
                    await loadRowerDataByDate()
                }.task(id: selectedRover){
                    await loadRowerDataByDate()
                }
            }
            
            if(!selectedImage.isEmpty){
                
                AsyncImage(url: URL(string: selectedImage)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                
                
            }
            Spacer()
        }
        .padding()
    }
    
    
    
    func loadRowerDataByDate() async{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/\(selectedRover)/photos?earth_date=\(dateFormatter.string(from: date))&api_key=\(apikey)") else {
            print("Invalid URL")
            return
        }
        
        do {
            print(url)
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let outputStr  = String(data: data, encoding: String.Encoding.utf8)! as String
            print(outputStr)
            
            
           if let decodedResponse = try? JSONDecoder().decode(Images.self, from: data) {
                imagesByDate = decodedResponse.photos
             }
            
            // more code to come
        } catch {
            print("Invalid data")
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Rover: Identifiable, Hashable{
    var id = UUID()
    var name: String
}

//Json structure
struct Images: Codable{
    var photos: [RoverImage]
}

struct RoverImage : Codable{
    var id: Int
    var img_src: String
    var camera: Camera
}

struct Camera: Codable{
    var name: String
}
