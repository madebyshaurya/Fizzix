import SwiftUI
import CoreText

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea(.all)
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                    .opacity(0.1)
                    HomeView()
            }
        }
    }
}


