//
//  ContentView.swift
//  PhotosPickerDemo
//
//  Created by Chandrachudh K on 25/01/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    // State Properties
    @State var photoItem: PhotosPickerItem?
    @State var photoData: Data?
    @State var noPhoto: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 50) {
                if let photoData {
                    Image(uiImage: UIImage(data: photoData)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(16)
                        .shadow(color: .black, radius: 3, x: 0, y: 0)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .font(.largeTitle.bold())
                        .foregroundColor(.myGreen)
                        .aspectRatio(contentMode: .fit)
                }
                
                PhotosPicker(selection: $photoItem,
                             matching: .images,
                             preferredItemEncoding: .automatic) {
                    Label(photoItem == nil ? "Select Photo" : "Replace Photo", systemImage: "photo")
                }
                             .tint(.white)
                             .font(.largeTitle.bold())
                             .padding()
                             .background(Color.myGreen)
                             .cornerRadius(16)
                             .shadow(color: .black, radius: 3, x: 0, y: 0)
            }
            .padding()
            .onChange(of: photoItem) { newValue in
                if let newValue {
                    Task {
                        await updatePhotosPickerItem(with: newValue)
                    }
                }
            }
            
            if noPhoto {
                Rectangle()
                    .fill(.white)
                    .frame(width: 200, height: 150)
                    .overlay {
                        Text("No Photo")
                            .font(.largeTitle.bold())
                            .foregroundColor(.myGreen)
                    }
                    .cornerRadius(16)
                    .shadow(color: .black, radius: 3, x: 0, y: 0)
                    .onTapGesture {
                        noPhoto = false
                        photoItem = nil
                        photoData = nil
                    }
            }
        }
    }
    
    private func updatePhotosPickerItem(with item: PhotosPickerItem) async {
        if let data = try? await item.loadTransferable(type: Data.self) {
            photoData = data
            noPhoto = false
        } else {
            noPhoto = true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
