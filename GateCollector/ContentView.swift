import SwiftUI
import PencilKit
import PhotosUI

struct ContentView: View {
    
    @State private var andCount = 0
    @State private var orCount = 0
    @State private var nandCount = 0
    @State private var norCount = 0
    @State private var notCount = 0
    @State private var xorCount = 0
    @State private var xnorCount = 0
    
    @State private var selectedGate = "AND"
    @State private var canvasView = PKCanvasView()
    @State private var showingSaveConfirmation = false
    @State private var savedImagePath = ""
    let gates = ["AND", "OR", "NAND", "NOR", "NOT", "XOR", "XNOR"]
    
    var body: some View {
        VStack {
            
                Text("Please draw \(selectedGate) Gate.")
                    .font(.system(size: 20, weight: .black, design: .monospaced))
                    .contentTransition(.numericText())
                    .animation(.snappy, value: selectedGate)
        
            
            Picker("Select Logic Gate", selection: $selectedGate) {
                ForEach(gates, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.black)
                    .frame(width: 310, height: 310)
                
                DrawingCanvas(canvasView: $canvasView)
                    .frame(width: 300, height: 300)
                    .background(Color(UIColor.secondarySystemBackground))
                    .padding()
                
            }
            HStack {
                Button("Save") {
                    saveDrawing()
                    
                    if selectedGate == "AND" {
                        andCount += 1
                    } else if selectedGate == "OR" {
                        orCount += 1
                    } else if selectedGate == "NAND" {
                        nandCount += 1
                    } else if selectedGate == "NOR" {
                        norCount += 1
                    } else if selectedGate == "NOT" {
                        notCount += 1
                    } else if selectedGate == "XOR" {
                        xorCount += 1
                    } else if selectedGate == "XNOR" {
                        xnorCount += 1
                    }
                    
                    
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            
            Text("AND: \(andCount), OR: \(orCount), NAND: \(nandCount), NOR: \(norCount), NOT: \(notCount), XOR: \(xorCount), XNOR: \(xnorCount)")
                .font(.system(size: 20, weight: .regular, design: .monospaced))
                .contentTransition(.numericText())
                .animation(.snappy)
        }
        .preferredColorScheme(.light)
    }
    
    private func saveDrawing() {
        let image = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
        if let jpgData = image.jpegData(compressionQuality: 1.0) {
            savedImagePath = saveImageToDocuments(jpgData: jpgData)
            clearCanvas()
            showingSaveConfirmation = true
        }
    }
    
    private func saveImageToDocuments(jpgData: Data) -> String {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "LogicGate_\(selectedGate)_\(UUID().uuidString).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try jpgData.write(to: fileURL)
            print("Saved image to: \(fileURL)")
            return fileName
            
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return "Error: Unable to save"
        }
    }
    
    private func clearCanvas() {
        canvasView.drawing = PKDrawing()
    }
}

struct DrawingCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        let color = PKInkingTool.convertColor(.white, from: .light, to: .dark)
        
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: color, width: 5)
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

#Preview {
    ContentView()
}
