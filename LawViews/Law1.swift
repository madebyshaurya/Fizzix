import SwiftUI
import SpriteKit
import GameplayKit
import AVFoundation

struct Law1: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> 
    @State var counter = 0
    @State var biggerCard = false
    @State private var moveRight = false
    @State var instructionNum = 0
    @State var pickLawOfMotionView = PickLawOfMotionView()
    @State var instructions: [String] = [
        "Hey! In this interactive simulation you will learn about the first law of motion.",
        "The first law of motion says \"An object at rest remains at rest, or if in motion, remains in motion at a constant velocity unless acted on by a net external force.\" 📖",
        "Let's say that our object at rest is the crate. 📦",
        "Drag the car to the crate to move it. 🚗",
        "👏 Awesome! The crate was at rest 𝘶𝘯𝘵𝘪𝘭 it was acted upon by a net external force (which was the car 🚗). Now you know Newton's 1st law of motion!"
    ]
    @State var rightButtonDisabled = false
    @State var leftButtonDisabled = true
    @State var checkForCompletion = false
    @State var navigationButtonsVisible = true
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
        ZStack {
            Color.white
                .ignoresSafeArea(.all)
            Image("law1bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
                .opacity(0.8)
            VStack(spacing: 30) {
                    Text("Law 1")
                        .foregroundStyle(.black)
                        .font(.custom("RubikDoodleShadow-Regular", size: 65))
                
                SpriteView(scene: GameScene1(size: CGSize(width: 500, height: 400), law1View: self))
                    .frame(width: 500, height: 400)
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .overlay {
                        Image(systemName: "hand.tap")
                            .shadow(radius: 10)
                            .font(.custom("", size: 50))
                            .foregroundStyle(.yellow)
                            .padding(.trailing, moveRight ? 290 : 0)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: moveRight)
                            .onAppear {
                                withAnimation {
                                    self.moveRight.toggle()
                                }
                            }
                            .opacity(checkForCompletion ? 1 : 0)
                        
                    }
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .frame(width: 500, height: self.biggerCard ? 190 : 100)
                    .animation(.bouncy, value: biggerCard)
                    .confettiCannon(counter: $counter, num: 25, radius: 500)
                    .overlay {
                        Text(instructions[instructionNum])
                            .foregroundColor(.white)
                            .font(.custom("KleeOne-Regular", size: 23))
                            .padding(.horizontal, 10)
                            .padding(7)
                            .padding(.bottom, biggerCard ? 30 : 10)
                            .padding(.bottom, instructionNum == 3 ? 30 : 0)
                        
                        Button {
                            if instructionNum == 0 {
                                leftButtonDisabled = true
                            } else {
                                leftButtonDisabled = false
                                instructionNum -= 1
                            }
                            
                            if instructionNum == 1 || instructionNum == 4 {
                                biggerCard = true
                            } else {
                                biggerCard = false
                            }
                            
                        } label: {
                            Image(systemName: "arrow.backward.circle")
                                .font(.custom("KleeOne-Regular", size: 25))
                                .foregroundStyle(checkForCompletion || leftButtonDisabled ? .yellow.opacity(0.5) : .yellow)
                        }
                        .padding(.leading, 350)
                        .padding(.top, biggerCard ? 140 : 40)
                        .disabled(checkForCompletion)
                        .opacity(navigationButtonsVisible ? 1 : 0)
                        .disabled(!navigationButtonsVisible)
                        .disabled(leftButtonDisabled)
                        
                        Button{
                            if instructionNum == 2 {
                                checkForCompletion = true
                            }
                            
                            if instructionNum == 4 {
                                instructionNum = 0
                            } else {
                                leftButtonDisabled = false
                                instructionNum += 1
                            }
                            
                            if instructionNum == 1 || instructionNum == 4 {
                                biggerCard = true
                            } else {
                                biggerCard = false
                            }
                        } label: {
                            Image(systemName: "arrow.forward.circle")
                                .font(.custom("KleeOne-Regular", size: 25))
                                .foregroundStyle(rightButtonDisabled || checkForCompletion ? .yellow.opacity(0.5) : .yellow)
                        }
                        .onChange(of: instructionNum, { oldValue, newValue in
                            
                            if instructionNum != 3 && newValue == oldValue + 1 {
                                rightButtonDisabled.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    rightButtonDisabled.toggle()
                                }
                            }
                            
                        })
                        .disabled(rightButtonDisabled || checkForCompletion)
                        .padding(.leading, 440)
                        .padding(.top, biggerCard ? 140 : 40)
                        .opacity(navigationButtonsVisible ? 1 : 0)
                        .disabled(!navigationButtonsVisible)
                        
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                                pickLawOfMotionView.currentIndex = 1
                        } label: {
                            Text("Keep Learning 📚")
                                .font(.custom("KleeOne-Regular", size: 17))
                        }
                        .frame(width: 200)
                        .buttonStyle(.borderedProminent)
                        .opacity(!navigationButtonsVisible ? 1 : 0)
                        .disabled(navigationButtonsVisible)
                        .padding(.top, 120)
                        .padding(.leading, 318)
                        
                    }
            }
        }
    }
}

class GameScene1: SKScene, SKPhysicsContactDelegate {
    
    private var law1View: Law1?
    
    init(size: CGSize ,law1View: Law1?) {
        self.law1View = law1View
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var car = SKSpriteNode(texture: SKTexture(imageNamed: "car"))
    private var box = SKSpriteNode(texture: SKTexture(imageNamed: "crate"), size: CGSize(width: 70, height: 70))
    private var terrain = SKShapeNode(rectOf: CGSize(width: 500, height: 10))
    private var carIsMovable = true
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = .white
        
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 70, height: 70))
        box.physicsBody?.affectedByGravity = true
        box.physicsBody?.collisionBitMask = .max
        box.name = "crate"
        box.physicsBody?.isDynamic = true
        box.physicsBody?.friction = 0.5
        box.position = .init(x: 200, y: 450)
        addChild(box)
        
        car.xScale = -1;
        car.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "car"), size: car.texture!.size())
        car.name = "car"
        car.physicsBody?.affectedByGravity = true
        car.physicsBody?.collisionBitMask = .max
        car.physicsBody?.contactTestBitMask = car.physicsBody?.collisionBitMask ?? 0
        car.physicsBody?.isDynamic = true
        car.constraints = [SKConstraint.zRotation(SKRange(upperLimit: 1))]
        car.position = .init(x: 70, y: 450)
        addChild(car)
        
        terrain.strokeColor = .brown
        terrain.fillColor = .brown
        terrain.name = "terrain"
        terrain.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 10))
        terrain.physicsBody?.affectedByGravity = false
        terrain.physicsBody?.isDynamic = false
        terrain.position = .init(x: 200, y: 150)
        addChild(terrain)
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "crate" && contact.bodyB.node?.name == "car" {
            if let law1 = law1View {
                if law1.instructionNum == 3 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        law1.instructionNum = 3
                        law1.instructionNum += 1
                        law1.counter += 1
                        law1.navigationButtonsVisible = false
                        law1.checkForCompletion = false
                        law1.biggerCard = true
                    }
                }
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if (!intersects(car)) {
            car.position = CGPoint(x: 100, y: 300)
        }
        
        if (!intersects(box)) {
            box.position = CGPoint(x: 200, y: 300)
        }
        
        if box.position.x >= 400 {
            
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if carIsMovable == true {
                car.position.x = location.x
            }
        }
    }
    
    
    
}
