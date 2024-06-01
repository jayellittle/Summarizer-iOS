//
//  IntroductionView.swift
//  Summarizer-iOS
//
//  Created by Woo Sung Jahng on 2024/06/02.
//

import SwiftUI

struct IntroductionView: View {
    @State private var showMainView = false
    
    var body: some View {
        VStack {
            Text("Summarizer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Summarize everything.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                showMainView = true
            }) {
                Text("Start")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }

        .fullScreenCover(isPresented: $showMainView) {
            ContentView()
        }
    }
}

#Preview {
    IntroductionView()
}
