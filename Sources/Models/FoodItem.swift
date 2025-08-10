import Foundation
import SwiftData

@Model
final class FoodItem {
    var id: UUID = UUID()
    var name: String
    var brand: String?
    var servingSize: String
    var calories: Double
    var proteinG: Double
    var carbsG: Double
    var fatG: Double
    var barcode: String?
    var isFavorite: Bool = false
    var isUserCreated: Bool = false

    init(name: String, brand: String? = nil, servingSize: String, calories: Double, proteinG: Double, carbsG: Double, fatG: Double, barcode: String? = nil, isFavorite: Bool = false, isUserCreated: Bool = false) {
        self.name = name
        self.brand = brand
        self.servingSize = servingSize
        self.calories = calories
        self.proteinG = proteinG
        self.carbsG = carbsG
        self.fatG = fatG
        self.barcode = barcode
        self.isFavorite = isFavorite
        self.isUserCreated = isUserCreated
    }
}
