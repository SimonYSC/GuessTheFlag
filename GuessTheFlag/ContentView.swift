//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by YunShou Chao on 7/2/21.
//

import SwiftUI

enum AlertType {
    case score, restart
}

struct FlagImage: View {
    let name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Monaco", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showAlert = false
    @State private var activeAlert = AlertType.score
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var rotateAmount = [0.0, 0.0, 0.0]
    @State private var opacityAmount = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
//                        Image(self.countries[number])
//                            .renderingMode(.original)
//                            .clipShape(Capsule())
//                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
//                            .shadow(color: .black, radius: 2)
                        FlagImage(name: self.countries[number])
                    }
                    .opacity(opacityAmount[number])
                    .animation(.default)
                    .rotation3DEffect(
                        .degrees(rotateAmount[number]),
                        axis: (x: 0, y: 1, z: 0)
                    )
                }
                
                Spacer()
                
                VStack {
                    Text("\(score)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
                
                Spacer()
                
                Button(action: {
                    restartTapped()
                }) {
                    Text("Restart")
                }
            }
        }
        .alert(isPresented: $showAlert) {
            switch activeAlert {
            case .score:
                return Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
            case .restart:
                return Alert(title: Text("Restart"), message: Text("You started a new game!"), dismissButton: .default(Text("OK")) {
                    self.askQuestion()
                })
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(score)"
            withAnimation {
                rotateAmount[number] += 360
            }
            for num in 0..<opacityAmount.count {
                if num != number {
                    opacityAmount[num] -= 0.25
                }
            }
        } else {
            score -= 1
            scoreTitle = "Wrong"
            scoreMessage = "Too bad, that's the flag of \(countries[number])"
        }
        
        activeAlert = .score
        showAlert = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityAmount = [1.0, 1.0, 1.0]
    }
    
    func restartTapped() {
        activeAlert = .restart
        showAlert = true
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
