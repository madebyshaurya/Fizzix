import SwiftUI

struct Question {
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
}

struct QuizView: View {
    @State private var currentQuestionIndex = 0
    @State private var selectedOptionIndex: Int?
    @State private var quizFinished = false
    @State private var correctQuestions = 0
    
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
    
    let questions = [
        Question(text: "If Jake pushes a shopping cart while the cart was stationary, what law does this scenario represent? 🛒", options: ["Law #1", "Law #2", "Law #3"], correctAnswerIndex: 0),
        Question(text: "Jacob is saying that a bike's mass and force vary the acceleration. However, Sophie is saying that only the force impacts the acceleration. Who is right? 🤨", options: ["None of them", "Jacob", "Sophie"], correctAnswerIndex: 1),
        Question(text: "A rocket launches into space, expelling gases downward. According to Newton's third law, which of the following occurs as a result of this action?", options: ["The ground reacts to the force exerted by the gases.", "The gases exert a force on the rocket.", "The rocket experiences an equal and opposite force."], correctAnswerIndex: 2),
        Question(text: "According to Newton's second law, the acceleration of an object is directly proportional to the net force acting on it and inversely proportional to its: 🚀", options: ["Mass", "Volume", "Density", "Velocity"], correctAnswerIndex: 0),
        Question(text: "Newton's third law states that for every action, there is an equal and opposite: ⚖️", options: ["Force", "Reaction", "Momentum", "Acceleration"], correctAnswerIndex: 1),
        Question(text: "According to Newton's second law, what is the relationship between force (F), mass (m), and acceleration (a)? 🔍", options: ["F = m/a", "F = a/m", "F = m × a", " F = m + a"], correctAnswerIndex: 2),
        Question(text: "Why does a car accelerate when a force is applied? 🚗", options: ["First Law", "Second Law", "Third Law"], correctAnswerIndex: 1),
        Question(text: "Why does a box remain at rest or move with constant velocity on a frictionless incline? 📦", options: ["First Law", "Second Law", "Third Law"], correctAnswerIndex: 0),
        Question(text: "What law explains why a rocket moves upwards when launching? 🚀", options: ["First Law", "Second Law", "Third Law"], correctAnswerIndex: 2),
        Question(text: "Why does a book placed on a table not move unless an external force is applied? 📚", options: ["First Law", "Second Law", "Third Law"], correctAnswerIndex: 0),

    ]
    
    var body: some View {
        if quizFinished {
            QuizFinishedView(quizFinished: $quizFinished, currentIndex: $currentQuestionIndex, correctQuestion: $correctQuestions, correctPercentage: calculatePercentage())
        } else {
            VStack {
                ZStack {
                    Color.white
                        .ignoresSafeArea(.all)
                    Image("bg2")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .opacity(0.1)
                    VStack {
                        ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count)).animation(.easeIn(duration: 3), value: currentQuestionIndex)
                            .scaleEffect(x: 1, y: 4, anchor: .center)
                        
                        Text(questions[currentQuestionIndex].text)
                            .font(.custom("KleeOne-Regular", size: 30))
                            .foregroundColor(.black)
                            .padding()
                        
                        if !quizFinished {
                            ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                                Button(action: {
                                    self.selectedOptionIndex = index
                                }) {
                                    Text(self.questions[self.currentQuestionIndex].options[index])
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(self.selectedOptionIndex == index ? Color.blue : Color.gray.opacity(0.7))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                        .font(.custom("KleeOne-Regular", size: 30))
                                }
                                .padding(.bottom, 10)
                            }
                            
                            Button(action: {
                                self.checkAnswer()
                            }) {
                                Text("Next")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .font(.custom("KleeOne-Regular", size: 30))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                            .disabled(self.selectedOptionIndex == nil)
                            .opacity(self.selectedOptionIndex == nil ? 0.6 : 1.0)
                        }
                    }
                    .padding(.horizontal, 150)
                }
            }
        }
    }
    
    func checkAnswer() {
        guard let selectedOptionIndex = selectedOptionIndex else { return }
        
        if selectedOptionIndex == questions[currentQuestionIndex].correctAnswerIndex {
            correctQuestions += 1
            // Correct Answer
            print("Correct!")
        } else {
            // Incorrect Answer
            print("Incorrect!")
        }
        
        // Reset state for next question
        self.selectedOptionIndex = nil
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
        } else {
            // Quiz finished
            self.quizFinished = true
            print("Quiz Finished!")
        }
    }
    
    func calculatePercentage() -> Int {
        guard !questions.isEmpty else { return 0 }
        return (correctQuestions * 100) / questions.count
    }
}

struct QuizFinishedView: View {
    @Binding var quizFinished: Bool
    @Binding var currentIndex: Int
    @Binding var correctQuestion: Int
    let correctPercentage: Int
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                Text("Quiz Finished!")
                    .font(.custom("KleeOne-Regular", size: 50))
                    .foregroundColor(.white)
                    .padding()
                Text("You got \(correctPercentage)% correct")
                    .font(.custom("KleeOne-Regular", size: 30))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        Text("Menu")
                            .font(.custom("KleeOne-Regular", size: 20))
                            .foregroundStyle(.white)
                        Button { 
                            self.presentationMode.wrappedValue.dismiss()
                        } label: { 
                            Image(systemName: "arrowshape.backward.circle.fill")
                                .font(.custom("KleeOne-Regular", size: 70))
                                .foregroundStyle(.white)
                        }
                    }
                    Spacer()
                    VStack {
                        Text("Restart")
                            .font(.custom("KleeOne-Regular", size: 20))
                            .foregroundStyle(.white)
                        Button(action: {
                            correctQuestion = 0
                            quizFinished = false
                            currentIndex = 0
                        }) {
                            Image(systemName: "arrow.circlepath")
                                .font(.custom("KleeOne-Regular", size: 70))
                                .foregroundStyle(.white)
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
