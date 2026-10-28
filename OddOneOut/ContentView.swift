import SwiftUI

struct ContentView: View {
    static let gridSize = 10
    @State private var images = ["elephant", "giraffe", "hippo", "monkey", "panda", "parrot", "penguin", "pig", "rabbit", "snake"]
    @State private var layout = Array(repeating: "hippo", count: gridSize * gridSize)
    @State private var currentLevel = 1
    @State private var isGameOver = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Odd One Out")
                    .font(.system(size: 36, weight: .thin))
                    .fixedSize()
                
                ForEach(0..<Self.gridSize, id: \.self) { row in
                    HStack {
                        ForEach(0..<Self.gridSize, id: \.self) { column in
                            if image(row, column) == "empty" {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 64, height: 64)
                            } else {
                                Button {
                                    processAnswer(at: row, column)
                                } label: {
                                    Image(image(row, column))
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
            }
            .opacity(isGameOver ? 0.2 : 1)
            
            if isGameOver {
                VStack {
                    Text("Game over!")
                        .font(.largeTitle)
                    
                    Button("Play Again") {
                        currentLevel = 1
                        isGameOver = false
                        createLevel()
                    }
                    .buttonStyle(.borderless)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(20)
                    .background(.blue)
                    .clipShape(.capsule)
                }
            }
        }
        .onAppear(perform: createLevel)
        .contentShape(Rectangle())
        .contextMenu {
            Button("Start New Game") {
                currentLevel = 1
                isGameOver = false
                createLevel()
            }
        }
    }
    
    private func processAnswer(at row: Int, _ column: Int) {
        if image(row, column) == images[0] {
            // they clicked the correct animal
            currentLevel += 1
        } else {
            // they clicked the wrong animal
            if currentLevel > 1 {
                // take the current level down if we can
                currentLevel -= 1
            }
        }
        
        createLevel()
    }
    
    private func generateLayout(items: Int) {
        // remove any existing layouts
        layout.removeAll(keepingCapacity: true)
        
        // randomize the image order, and consider the first image to be the correct animal
        images.shuffle()
        layout.append(images[0])
        
        // prepare to loop through the other animals
        var numUsed = 0
        var itemCount = 1
        
        for _ in 1..<items {
            // place the current animal image and add to the counter
            layout.append(images[itemCount])
            numUsed += 1
            
            if numUsed == 2 {
                numUsed = 0
                itemCount += 1
            }
            
            if itemCount == images.count {
                itemCount = 1
            }
        }
        
        // fill the remaining of the array with empty rectangles then shuffle the layout
        layout += Array(repeating: "empty", count: 100 - layout.count)
        layout.shuffle()
    }
    
    private func createLevel() {
        if currentLevel == 9 {
            withAnimation {
                isGameOver = true
            }
        } else {
            let numbersOfItems = [0, 5, 15, 25, 35, 49, 65, 81, 100]
            generateLayout(items: numbersOfItems[currentLevel])
        }
    }
    
    private func image(_ row: Int, _ column: Int) -> String {
        layout[row * Self.gridSize + column]
    }
}

#Preview {
    ContentView()
}

