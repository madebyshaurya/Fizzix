import SwiftUI
import AVFoundation

struct HomeView: View {
    @State var soundStopped = false
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
            print("Failed to register custom font 'anotherFont'.")
        }
    }
    var body: some View {
        VStack {
            Group {
                Text("Fizzix")
                    .foregroundStyle(.black)
                    .font(Font.custom("RubikDoodleShadow-Regular", size: 65))
                    .padding(.horizontal)
                
            }
            
            
            Text("Newton's laws of motion play a role in how objects behave in our lives. These principles are key to grasping concepts related to motion, forces and interactions serving as the foundation of mechanics. Engaging with these laws through learning enhances our understanding and admiration for the world around us. 🌏")
                .multilineTextAlignment(.center)
                .frame(width: 650)
                .foregroundStyle(.black)
                .lineLimit(10)
                .font(Font.custom("KleeOne-Regular", size: 20))
            
            VStack(spacing: 60) {
                
                NavigationLink {
                    PickLawOfMotionView()
                } label: {
                    Text("Laws of Motion 🏃")
                        .foregroundStyle(.white)
                        .font(Font.custom("KleeOne-Regular", size: 40))
                        .frame(width: 450, height: 75)
                        .background(.green)
                        .cornerRadius(15)
                }
                
                
                NavigationLink {
                    QuizView()
                } label: {
                    Text("Quiz 🤔")
                        .foregroundStyle(.white)
                        .font(Font.custom("KleeOne-Regular", size: 40))
                        .frame(width: 450, height: 75)
                        .background(.yellow)
                        .cornerRadius(15)
                }
                
//                NavigationLink {
//                    
//                } label: {
//                    Text("About Me 😃")
//                        .foregroundStyle(.white)
//                        .font(Font.custom("KleeOne-Regular", size: 40))
//                        .frame(width: 450, height: 75)
//                        .background(.red)
//                        .cornerRadius(15)
//                }
                
                NavigationLink { 
                    Credits()
                } label: { 
                    Text("Credits 📝")
                        .foregroundStyle(.white)
                        .font(Font.custom("KleeOne-Regular", size: 20))
                        .frame(width: 120, height: 40)
                        .background(.blue)
                        .cornerRadius(15)
                }
            }
            .padding(.top, 80)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) { 
                HStack {
                    Button(action: {
                    }, label: {
                        Image(systemName: "speaker.wave.2.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.clear)
                    })
                    Spacer()
                        Button(action: {
                            if !soundStopped {
                                stopSounds()
                                soundStopped = true
                            } else {
                                playSound(sound: "bgmusic", type: "mp3", volume: 0.4, loop: -1)
                                soundStopped = false
                            }
                        }, label: {
                            Image(systemName: soundStopped ? "speaker.slash.circle.fill": "speaker.wave.2.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.gray)
                                .contentTransition(.symbolEffect(.replace))
                        })
                        .padding(.bottom, 10)
                }
            }
        }
        .onAppear(perform: {
            if !soundStopped {
                playSound(sound: "bgmusic", type: "mp3", volume: 0.4, loop: -1)
            }
        })
    }
}
