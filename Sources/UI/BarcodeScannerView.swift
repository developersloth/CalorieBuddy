import SwiftUI
import AVFoundation
import SwiftData

struct BarcodeScannerView: View {
    @Environment(\.modelContext) private var context
    @State private var detectedCode: String?
    @State private var foundItem: FoodItem?
    @State private var servings: Double = 1.0

    var body: some View {
        VStack {
            CameraView(detectedCode: $detectedCode).frame(height: 320)
            if let code = detectedCode {
                Text("Detected: \(code)").font(.caption)
                if let item = foundItem {
                    Text("Found: \(item.name)").font(.headline)
                    Stepper(value: $servings, in: 0.25...10, step: 0.25) { Text("\(servings, specifier: "%.2f")Ã—") }.padding()
                    Button("Add to Today") { let log = FoodLog(date: .now, food: item, servings: servings); context.insert(log); try? context.save() }.buttonStyle(.borderedProminent)
                } else { Text("Not in library. Create it in 'Custom Food'.").foregroundStyle(.secondary) }
            } else { Text("Point camera at a barcode.").foregroundStyle(.secondary) }
        }
        .padding()
        .navigationTitle("Scan Barcode")
        .onChange(of: detectedCode) { code in guard let code else { return }; foundItem = BarcodeMapper.lookup(code, context: context) }
    }
}

final class CameraCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    @Binding var code: String?
    init(code: Binding<String?>) { _code = code }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let str = obj.stringValue else { return }
        code = str
    }
}

struct CameraView: UIViewRepresentable {
    @Binding var detectedCode: String?
    func makeCoordinator() -> CameraCoordinator { CameraCoordinator(code: $detectedCode) }
    func makeUIView(context: Context) -> UIView {
        let view = UIView(); let session = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: .video), let input = try? AVCaptureDeviceInput(device: device) else { return view }
        let output = AVCaptureMetadataOutput()
        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(output) { session.addOutput(output) }
        output.setMetadataObjectsDelegate(context.coordinator, queue: .main); output.metadataObjectTypes = [.ean13, .ean8, .upce]
        let preview = AVCaptureVideoPreviewLayer(session: session); preview.videoGravity = .resizeAspectFill; preview.frame = UIScreen.main.bounds; view.layer.addSublayer(preview)
        session.startRunning(); return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}
