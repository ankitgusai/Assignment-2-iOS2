//
//  ContentView.swift
//  Assignment1
//
//  Created by Ankitgiri Gusai on 2023-02-05.
//

import SwiftUI

struct SelectImageView: View {
    let rovers = [
        Rover(name: "Curiosity"),
        Rover(name: "Opportunity"),
        Rover(name: "Spirit")
    ]
    @State var selectedImage = 0
    @State var selectedRover = "Curiosity"
    @State private var date = Date()
    @State private var imagesByDate = [RoverImage]()
    @State private var image: UIImage?
    @State private var isImageLoaded = false
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    
    private let apikey = "vWd12qb1VeuciCNy5SoKcPeovpFWmtnKIX16zEsH"
    
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Select Image").font(.title3)
            
            Divider().padding()
            
            VStack{
                
                Text("Select a Rover").frame(maxWidth: .infinity, alignment: .leading)
                
                Picker("Select a Rover", selection: $selectedRover){
                    ForEach(rovers, id: \.name) { rover in
                        Text(rover.name)
                    }
                }.pickerStyle(.segmented)
                
                Divider().padding()
            }
            
            DatePicker("Pick a date", selection: $date, in: ...Date(), displayedComponents: [.date])
            
            Divider().padding()
            
            HStack {
                
                
                if(imagesByDate.count > 0){
                    Text("Select Image")
                }
                
                Spacer()
                Picker("Pick an image", selection: $selectedImage){
                    ForEach(Array(imagesByDate.enumerated()), id: \.offset) { index, image in
                        Text("\(image.id) (\(image.camera.name) cam)").tag(index)
                    }
                }.onSubmit {
                    isImageLoaded = false
                }
                
                
                .padding()
                .task(id: date) {
                    await loadRowerDataByDate()
                }.task(id: selectedRover){
                    await loadRowerDataByDate()
                }
            }
            
            if(selectedImage > 0){
                
                AsyncImage(url: URL(string: imagesByDate[selectedImage].img_src)) { image in
                    image.resizable()
                        .onAppear{
                            isImageLoaded = true
                            self.image = image.snapshot()
                        }
                    
                } placeholder: {
                    ProgressView()
                }
                
                
            }
            Spacer()
            
            
            if(isImageLoaded){
                Button("Save this Image") {
                    let selectedImage = imagesByDate[selectedImage]
                    let coreDataImage = MarsImage(context: moc)
                    coreDataImage.id = Int32(selectedImage.id)
                    coreDataImage.url = selectedImage.img_src
                    coreDataImage.camera = selectedImage.camera.name
                    coreDataImage.rover = selectedRover
                    coreDataImage.date = selectedImage.earth_date
                    
                    print(coreDataImage)
                    
                    if let image = self.image {
                        
                        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                            return
                        }
                        let fileURL = documentsDirectory.appendingPathComponent("\(selectedImage.id).jpg")
                        if let imageData = image.jpegData(compressionQuality: 1.0) {
                            try? imageData.write(to: fileURL, options: [.atomic])
                            print("Saved image to \(fileURL)")
                        }
                        
                    }
                    
                    try? moc.save()
                    dismiss()
                    
                }.buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
    
    
    
    func loadRowerDataByDate() async{
        print("loadRowerDataByDate")
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
            
            
            if let decodedResponse = try? JSONDecoder().decode(Images.self, from: data) {
                print("decode response size \(decodedResponse.photos.count)")
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
        SelectImageView()
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
    var earth_date: String
}

struct Camera: Codable{
    var name: String
}


extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
