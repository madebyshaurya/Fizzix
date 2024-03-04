import SwiftUI
import SpriteKit
import GameplayKit
import AVFoundation

struct Law2: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var counter = 0
    @State var biggerCard = false
    @State private var moveRight = false
    @State var instructionNum = 0
    @State var instructions: [String] = [
        "Nice job keeping up the momentum from the last lesson! ⌛️",
        "The second law of motion is a bit more interesting, it says that \"The force acting on an object is equal to the mass of that object times its acceleration, F=ma.\" 🚀",
        "Which just trying to say that to get the force the object will move with is equal to its mass time acceleration. 📖",
        "Also, the force is propotional to accelaration which we can get by a=f/m which is what you will experiencing in this lesson's interactive mission. 🧑‍💻",
        "Experiment with the values above 👆, try entering something like 20N and 10kg (don't write the unit).",
        "You did again! A pat on the back for learning about Newton's 2nd Law of Motion! 🎉"
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
                Text("Law 2")
                    .foregroundStyle(.black)
                    .font(.custom("RubikDoodleShadow-Regular", size: 65))
                
                SpriteView(scene: GameScene2(size: CGSize(width: 500, height: 400), law2View: self))
                    .frame(width: 500, height: 400)
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .frame(width: 500, height: self.biggerCard ? 190 : 100)
                    .animation(.bouncy, value: biggerCard)
                    .confettiCannon(counter: $counter, num: 100, radius: 500)
                    .overlay {
                        Text(instructions[instructionNum])
                            .foregroundColor(.white)
                            .font(.custom("KleeOne-Regular", size: 23))
                            .padding(.horizontal, 15)
                            .padding(7)
                            .padding(.bottom, biggerCard ? 30 : 10)
//                            .padding(.bottom, instructionNum == 3 ? 30 : 0)
                        
                        Button {
                            
                            if instructionNum == 0 {
                                leftButtonDisabled = true
                            } else {
                                leftButtonDisabled = false
                                instructionNum -= 1
                            }
                            
                            if instructionNum == 1 || instructionNum == 4 || instructionNum == 2 || instructionNum == 3 {
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
                            if instructionNum == 3 {
                                checkForCompletion = true
                            }
                            
                            if instructionNum == 4 {
                                instructionNum = 0
                            } else {
                                leftButtonDisabled = false
                                instructionNum += 1
                            }
                            
                            if instructionNum == 1 || instructionNum == 4 || instructionNum == 2 || instructionNum == 3 {
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


class GameScene2: SKScene {
    var elapsedTime = 0
    var speedTimer: Timer?
    let pixelsPerMeter: CGFloat = 100
    
    private var law2View: Law2?
    
    init(size: CGSize ,law2View: Law2?) {
        self.law2View = law2View
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var durationLabel = SKLabelNode(fontNamed: "KleeOne-Regular")
    var errorTextLabel = SKLabelNode(fontNamed: "KleeOne-Regular")
    var forceInputField: UITextField!
    var massInputField: UITextField!
    var moveButton: UIButton!
    var durationStepper: UIStepper!
    var terrain = SKShapeNode(rectOf: CGSize(width: 500, height: 10))
    var box = SKSpriteNode(texture: SKTexture(imageNamed: "crate"), size: CGSize(width: 70, height: 70))
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        errorTextLabel.text = ""
        errorTextLabel.fontSize = 20
        errorTextLabel.fontColor = SKColor.red
        errorTextLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        addChild(errorTextLabel)
        
        box.name = "crate"
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 70, height: 70))
        box.physicsBody?.affectedByGravity = true
        box.physicsBody?.collisionBitMask = .max
        box.name = "crate"
        box.physicsBody?.isDynamic = true
        box.physicsBody?.friction = 0.5
        box.position = .init(x: 75, y: 350)
        addChild(box)
        
        terrain.strokeColor = .brown
        terrain.fillColor = .brown
        terrain.name = "terrain"
        terrain.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 10))
        terrain.physicsBody?.affectedByGravity = false
        terrain.physicsBody?.isDynamic = false
        terrain.position = .init(x: 250, y: 210)
        addChild(terrain)
        
        durationStepper = UIStepper(frame: CGRect(x: 230, y: 30, width: 100, height: 50))
        durationStepper.layer.cornerRadius = 10
        durationStepper.backgroundColor = .black
        durationStepper.maximumValue = 5
        durationStepper.minimumValue = 1
        durationStepper.value = 3.0
        view.addSubview(durationStepper)
        
        durationLabel.text = "Duration: \(durationStepper.value)"
        durationLabel.fontSize = 20
        durationLabel.fontColor = .black
        durationLabel.position = CGPoint(x: 400, y: 345)
        addChild(durationLabel)
        
        forceInputField = UITextField(frame: CGRect(x: 20, y: 300, width: 200, height: 30))
        forceInputField.textAlignment = .center
        forceInputField.placeholder = "Enter Force (Newtons)"
        forceInputField.keyboardType = .numberPad
        forceInputField.backgroundColor = .gray
        forceInputField.textColor = .black
        forceInputField.layer.cornerRadius = 5
        forceInputField.layer.borderColor = .init(red: 0, green: 255, blue: 0, alpha: 1)
        forceInputField.layer.borderWidth = 2
        
        view.addSubview(forceInputField)
        
        massInputField = UITextField(frame: CGRect(x: 280, y: 300, width: 200, height: 30))
        massInputField.textAlignment = .center
        massInputField.placeholder = "Enter Mass (kg)"
        massInputField.keyboardType = .numberPad
        massInputField.backgroundColor = .gray
        massInputField.textColor = .black
        massInputField.layer.cornerRadius = 5
        massInputField.layer.borderColor = .init(red: 0, green: 0, blue: 150, alpha: 1)
        massInputField.layer.borderWidth = 2
        view.addSubview(massInputField)
        
        moveButton = UIButton(type: .system)
        moveButton.backgroundColor = .blue
        moveButton.tintColor = .white
        moveButton.layer.cornerRadius = 5
        moveButton.frame = CGRect(x: frame.midX-75, y: 350, width: 150, height: 30)
        moveButton.setTitle("Move Crate!", for: .normal)
        moveButton.addTarget(self, action: #selector(moveCrate), for: .touchDown)
        view.addSubview(moveButton)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (!intersects(box)) {
            box.position = .init(x: 75, y: 250)
        }
        durationLabel.text = "Duration: \(durationStepper.value)s"
    }
    
    @objc func moveCrate() {
        elapsedTime = 0
        speedTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: durationStepper.value, target: self, selector: #selector(endSpeedChange), userInfo: nil, repeats: false)
    }
    
    @objc func updateElapsedTime() {
        elapsedTime += 1
        changeSpeed(elapsedTime: elapsedTime)
    }
    
    @objc func changeSpeed(elapsedTime: Int) {
        guard let forceString = forceInputField.text,
              let massString = massInputField.text,
              let force = Double(forceString),
              let mass = Double(massString) else {
            return
        }
        
        if !(mass > 20) && !(mass < 1) {
            if (!(force > 100) && !(force < 1)) {
                errorTextLabel.text = ""
                let acceleration = force / mass
                
                print("Elapsed Time = \(elapsedTime) and acceleration is \(acceleration) and combined is \(CGFloat(Double(elapsedTime) * acceleration))")
                
                let moveAction = SKAction.moveBy(x: CGFloat((Double(elapsedTime) * acceleration) * pixelsPerMeter), y: 0, duration: 5)
                box.run(moveAction)
                
                if let law2 = law2View {
                    if law2.instructionNum == 4 {
                        law2.checkForCompletion = false
                        law2.instructionNum += 1
                        law2.counter += 1
                        law2.navigationButtonsVisible = false
                    }
                }
            } else {
                print("ran in force error")
                errorTextLabel.text = "Force input should be between 1N and 100N"
                forceInputField.text = ""
            }
        } else {
            print("ran in mass error")
            errorTextLabel.text = "Mass should be between 1kg and 20kg"
            massInputField.text = ""
        }
    }
    
    @objc func endSpeedChange() {
        // Invalidate the speed timer
        speedTimer?.invalidate()
        speedTimer = nil
    }

    
}


//class GameScene2: SKScene, SKPhysicsContactDelegate {
//    
//    private var law2View: Law2?
//    
//    init(size: CGSize ,law2View: Law2?) {
//        self.law2View = law2View
//        super.init(size: size)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private var car = SKSpriteNode(texture: SKTexture(imageNamed: "car"))
//    private var box = SKSpriteNode(texture: SKTexture(imageNamed: "crate"), size: CGSize(width: 70, height: 70))
//    private var terrain = SKShapeNode(rectOf: CGSize(width: 500, height: 10))
//    
//    override func didMove(to view: SKView) {
//        physicsWorld.contactDelegate = self
//        backgroundColor = .white
//        
//        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 70, height: 70))
//        box.physicsBody?.affectedByGravity = true
//        box.physicsBody?.collisionBitMask = .max
//        box.name = "crate"
//        box.physicsBody?.isDynamic = true
//        box.physicsBody?.friction = 0.5
//        box.position = .init(x: 250, y: 450)
//        addChild(box)
//        
//        car.xScale = -1;
//        car.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "car"), size: car.texture!.size())
//        car.name = "car"
//        car.physicsBody?.affectedByGravity = true
//        car.physicsBody?.collisionBitMask = .max
//        car.physicsBody?.contactTestBitMask = car.physicsBody?.collisionBitMask ?? 0
//        car.physicsBody?.isDynamic = true
//        car.constraints = [SKConstraint.zRotation(SKRange(upperLimit: 1))]
//        car.position = .init(x: 100, y: 450)
//        addChild(car)
//        
//        terrain.strokeColor = .brown
//        terrain.fillColor = .brown
//        terrain.name = "terrain"
//        terrain.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 10))
//        terrain.physicsBody?.affectedByGravity = false
//        terrain.physicsBody?.isDynamic = false
//        terrain.position = .init(x: 200, y: 240)
//        addChild(terrain)
//        
//        
//    }
//    
//    
//    
//}
