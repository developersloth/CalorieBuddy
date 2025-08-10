import Foundation
import SwiftData

struct BarcodeMapper {
    static func lookup(_ code: String, context: ModelContext) -> FoodItem? {
        let pred = #Predicate<FoodItem> { $0.barcode == code }
        return try? context.fetch(FetchDescriptor<FoodItem>(predicate: pred)).first
    }
}
