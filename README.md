# CalorieBuddy (iOS 18, SwiftUI + SwiftData)

Offline calorie tracking with TDEE calculation, barcode scanning (AVFoundation), nutrition label OCR (Vision), and **activity calories** via METs. No backend required.

## Build

```bash
brew install xcodegen
xcodegen generate
open CalorieBuddy.xcodeproj
```

Run on iOS simulator or device (camera requires device).

## Privacy Keys

- NSCameraUsageDescription â€” camera for barcode scanning
- NSPhotoLibraryUsageDescription â€” choose photo for OCR

## Tech

- SwiftUI, SwiftData (local storage)
- Charts (weekly calories)
- AVFoundation (barcodes: EAN-13/EAN-8/UPC-E)
- Vision + PhotosUI (on-device OCR)
- METs for activity energy: kcal = (MET * 3.5 * weight_kg / 200) * minutes
