import SwiftUI
import SpriteKit

struct Card: Identifiable {
    var id: UUID = .init()
    var title: String
    var subtitle: String
    var image: String
    var isClicked: Bool = false
}


struct PickLawOfMotionView: View {
    @State private var showInfoPopup: Bool = false
    @State var currentIndex: Int = 0

    
    @GestureState private var dragOffset: CGFloat = 0
    @State private var cards: [Card] = [
        Card(title: "Law #1", subtitle: "An object at rest remains at rest, or if in motion, remains in motion at a constant velocity unless acted on by a net external force.", image: ""), 
        Card(title: "Law #2", subtitle: "The force acting on an object is equal to the mass of that object times its acceleration, F=ma.", image: ""),
        Card(title: "Law #3", subtitle: "For every action, there is an equal and opposite reaction.", image: "")
    ]
    init() {
        // Register the first custom font
        if let fontURL = Bundle.main.url(forResource: "RubikDoodleShadow-Regular", withExtension: "ttf"),
           let fontData = try? Data(contentsOf: fontURL) as CFData,
           let provider = CGDataProvider(data: fontData),
           let font = CGFont(provider) {
            
            CTFontManagerRegisterGraphicsFont(font, nil)
            //            print("Custom font 'titleFont' registered successfully.")
        } else {
            print("Failed to register custom font 'titleFont'.")
        }
        
        // Register the second custom font
        if let anotherFontURL = Bundle.main.url(forResource: "KleeOne-Regular", withExtension: "ttf"),
           let anotherFontData = try? Data(contentsOf: anotherFontURL) as CFData,
           let anotherFontProvider = CGDataProvider(data: anotherFontData),
           let anotherFont = CGFont(anotherFontProvider) {
            
            CTFontManagerRegisterGraphicsFont(anotherFont, nil)
            //            print("Custom font 'anotherFont' registered successfully.")
        } else {
            print("Failed to register custom font 'anotherFont'")
        }
    }
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color(.white)
                        .ignoresSafeArea(.all)
                        .zIndex(-100)
                    Image("bg2")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea(.all)
                        .opacity(0.1)
                        .zIndex(-99)
                    
                    VStack {
                        Text("Ready to learn?")
                            .foregroundStyle(.black)
                            .font(Font.custom("RubikDoodleShadow-Regular", size: 60))
                        Text("Swipe through and click on the law of motion you would like to learn about 📖")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.black)
                            .font(.custom("KleeOne-Regular", size: 21))
                            .frame(width: 500)
                    }
                    .padding(.bottom, 650)
                    
                    VStack {
                        NavigationLink {
                            QuizView()
                        } label: {
                            Text("Quiz 🤔")
                                .foregroundStyle(.black)
                                .font(Font.custom("KleeOne-Regular", size: 30))
                                .frame(width: 400, height: 75)
                                .background(.yellow)
                                .cornerRadius(15)
                                .padding(.bottom)
                        }

                    }
                    .padding(.top, 650)
                    
                    
                    ForEach(0..<cards.count, id: \.self) { index in
                        
                        if cards[index].title == "Law #1" {
                            NavigationLink {
                                Law1()
                            } label: {
                                Image("law1")
                                    .resizable()
                                    .scaledToFit()
                                    .overlay { 
                                        Image(systemName:"play.circle.fill")
                                            .font(.custom("KleeOne-Regular", size: 50))
                                            .foregroundStyle(.blue)
                                    }
                            }
                            .frame(width: 350, height: 400)
                            .cornerRadius(15)
                            .opacity(currentIndex == index ? 1.0 : 0.5)
                            .scaleEffect(currentIndex == index ? 1.2 : 0.8)
                            .offset(x: CGFloat(index-currentIndex) * 300 + dragOffset, y: 0)
                            .onTapGesture {
                                cards[index].isClicked = true
                            }
                        } else if cards[index].title == "Law #2" {
                            NavigationLink {
                                Law2()
                            } label: {
                                Image("law2")
                                    .resizable()
                                    .scaledToFit()
                                    .overlay { 
                                        Image(systemName:"play.circle.fill")
                                            .font(.custom("KleeOne-Regular", size: 50))
                                            .foregroundStyle(.blue)
                                    }
                            }
                            .frame(width: 350, height: 400)
                            .cornerRadius(15)
                            .opacity(currentIndex == index ? 1.0 : 0.5)
                            .scaleEffect(currentIndex == index ? 1.2 : 0.8)
                            .offset(x: CGFloat(index-currentIndex) * 300 + dragOffset, y: 0)
                            .onTapGesture {
                                cards[index].isClicked = true
                            }
                            .zIndex(currentIndex == index ? 1 : -2)
                        } else if cards[index].title == "Law #3" {
                            NavigationLink {
                                Law3()
                            } label: {
                                Image("law3")
                                    .resizable()
                                    .scaledToFit()
                                    .overlay { 
                                        Image(systemName:"play.circle.fill")
                                            .font(.custom("KleeOne-Regular", size: 50))
                                            .foregroundStyle(.blue)
                                    }
                            }
                            .frame(width: 350, height: 400)
                            .cornerRadius(15)
                            .opacity(currentIndex == index ? 1.0 : 0.5)
                            .scaleEffect(currentIndex == index ? 1.2 : 0.8)
                            .offset(x: CGFloat(index-currentIndex) * 300 + dragOffset, y: 0)
                            .onTapGesture {
                                cards[index].isClicked = true
                            }
                            .zIndex(currentIndex == index ? 1 : -2)
                        } 
                        
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation { 
                                currentIndex = max(0, currentIndex - 1)
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation { 
                                currentIndex = min(cards.count - 1, currentIndex + 1)
                            }
                        }
                    })
            )
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) { 
                HStack{
                    Button {
                        withAnimation { 
                            currentIndex = max(0, currentIndex - 1)
                        }
                    } label: {
                        Image(systemName: "arrowshape.left.fill")
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation { 
                            currentIndex = min(cards.count - 1, currentIndex + 1)
                        }
                    } label: {
                        Image(systemName: "arrowshape.right.fill")
                            .font(.title)
                    }
                    
                }
            }
        }
    }
}
