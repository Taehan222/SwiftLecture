//
//  ContentView.swift
//  SwiftUIPractice
//
//  Created by 윤태한 on 3/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
            }else{
                Text("선택한 이미지가 없습니다")
                    .foregroundColor(.gray)
                Image(systemName: "plus")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .onTapGesture {
                        showImagePicker.toggle()
                    }
            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("이미지 선택"){
                self.showImagePicker.toggle()
                print(self.showImagePicker)
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker){
            // UIImagePicker를 사용할 객체 호출
            
            ImagePicker(selectedImage: self.$selectedImage)
        }
        .padding()
        
        
        
    }
    
}

#Preview {
    ContentView()
}
