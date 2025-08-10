import SwiftUI
import Vision
import PhotosUI

struct NutritionLabelOCRView: View {
    @State private var imageItem: PhotosPickerItem?
    @State private var uiImage: UIImage?
    @State private var parsed: (cals: Double, p: Double, c: Double, f: Double)?
    var body: some View {
        VStack(spacing: 16) {
            PhotosPicker(selection: $imageItem, matching: .images) { Text("Choose Nutrition Label Photo") }
            if let img = uiImage { Image(uiImage: img).resizable().scaledToFit().frame(height: 240) }
            if let p = parsed {
                VStack { Text("Calories: \(Int(p.cals)) kcal"); Text("Protein: \(p.p, specifier: "%.1f") g"); Text("Carbs: \(p.c, specifier: "%.1f") g"); Text("Fat: \(p.f, specifier: "%.1f") g") }.font(.headline)
            }
        }
        .padding()
        .navigationTitle("Scan Label")
        .onChange(of: imageItem) { _ in Task {
            if let data = try? await imageItem?.loadTransferable(type: Data.self), let img = UIImage(data: data) { uiImage = img; parsed = await OCRParser.parse(image: img) }
        }}
    }
}

enum OCRParser { static func parse(image: UIImage) async -> (Double, Double, Double, Double)? {
    guard let cgImage = image.cgImage else { return nil }
    let request = VNRecognizeTextRequest(); request.recognitionLevel = .accurate; request.usesLanguageCorrection = false
    let handler = VNImageRequestHandler(cgImage: cgImage); try? handler.perform([request])
    let text = request.results?.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "
") ?? ""
    func match(_ patterns: [String]) -> Double? { for p in patterns { if let r = try? NSRegularExpression(pattern: p, options: [.caseInsensitive]), let m = r.firstMatch(in: text, options: [], range: NSRange(text.startIndex..., in: text)), let range = Range(m.range(at: 1), in: text) { return Double(text[range]) } } ; return nil }
    let calories = match(["calories\s*(\d+)", "energy\s*(\d+)"]); let protein = match(["protein\s*(\d+(?:\.\d+)?)\s*g"]); let carbs = match(["carb[s]?\s*(\d+(?:\.\d+)?)\s*g"]); let fat = match(["fat\s*(\d+(?:\.\d+)?)\s*g"])
    guard let cals = calories else { return nil }; return (cals, protein ?? 0, carbs ?? 0, fat ?? 0)
}}
