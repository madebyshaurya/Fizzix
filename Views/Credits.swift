import SwiftUI


struct Credits: View {
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
        ZStack{
            Color(.white)
                .ignoresSafeArea(.all)
            Image("bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
                .opacity(0.1)
            VStack{
                Text("Credits")
                    .foregroundStyle(.black)
                    .font(.custom("RubikDoodleShadow-Regular", size: 60))
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Background Image:")
                        Text("[Image by brgfx](https://www.freepik.com/free-vector/science-objects-icons-seamless-pattern_40368055.htm#query=physics%20doodle%20background&position=3&from_view=search&track=ais&uuid=d2660c6b-dedc-4842-833a-54cbe9c0f6ec)")
                        Text("on Freepik")
                    }
                    .foregroundStyle(.black)
                    .font(.custom("KleeOne-Regular", size: 20))
                    
                    
                    HStack {
                        Text("Background Image 2:")
                        Text("Image by")
                        Text("[Freepik ](https://www.freepik.com/free-vector/flat-pattern-design-back-school-event_29401525.htm#query=learning%20doodle%20bg&position=29&from_view=search&track=ais&uuid=9403cb18-757e-4e55-bc5e-17984fe6b79c)")
                    }
                    .foregroundStyle(.black)
                    .font(.custom("KleeOne-Regular", size: 20))
                    
                    HStack {
                        Text("Skateboarding Boy:")
                        Text("Illustration by")
                        Text("[Icons 8](https://icons8.com/illustrations/author/zD2oqC8lLBBA) from")
                        Text("[Ouch!](https://icons8.com/illustrations)")
                    }
                    .foregroundStyle(.black)
                    .font(.custom("KleeOne-Regular", size: 20))
                    
                    HStack {
                        Text("Rocket:")
                        Text("Illustration by")
                        Text("[Liam Moore](https://icons8.com/illustrations/author/zD2oqC8lLBBA) from")
                        Text("[Ouch!](https://icons8.com/illustrations)")
                    }
                    .foregroundStyle(.black)
                    .font(.custom("KleeOne-Regular", size: 20))
                    
                    HStack {
                        Text("Boy Bouncing Ball:")
                        Text("Illustration by")
                        Text("[Icons 8](https://icons8.com/illustrations/author/zD2oqC8lLBBA) from")
                        Text("[Ouch!](https://icons8.com/illustrations)")
                    }
                    .foregroundStyle(.black)
                    .font(.custom("KleeOne-Regular", size: 20))
                    
                    HStack {
                        Text("[\"Pixel wooden crate\"](https://opengameart.org/content/pixel-wooden-crate) by PolygonixGames licensed CCO 1.0")
                    }
                    .foregroundStyle(.black)
                    .font(.custom("KleeOne-Regular", size: 20))
                    
                    HStack {
                        Text("Confetti Github Repo: [ConfettiSwiftUI](https://github.com/simibac/ConfettiSwiftUI)")
                        Text("on Freepik")
                    }
                    .foregroundStyle(.black)
                    .font(.custom("KleeOne-Regular", size: 20))
                    
                    HStack {
                        Text("All Law's Background Image:")
                        Text("[Image by rawpixel.com ](https://www.freepik.com/free-vector/pink-geometrical-patterned-background-vector_30086409.htm#query=app%20background%20math&position=2&from_view=search&track=ais&uuid=dece6284-30ee-40cf-b005-f1645c0d9022)")
                        Text("on Freepik")
                    }
                    .foregroundStyle(.black)
                    .font(.custom("KleeOne-Regular", size: 20))
                    
                }
                .padding(.top, 10)
                .padding(.leading, 20)
            }
        }
    }
}

// Image by <a href="https://www.freepik.com/free-vector/hand-drawn-science-education-background_7474222.htm#fromView=search&term=science+pattern&track=ais&regularType=vector&page=1&position=20&uuid=6f3198e2-eebe-4f15-ae42-103b17360c61">Freepik</a>
