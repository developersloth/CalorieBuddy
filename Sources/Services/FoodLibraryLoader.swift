import Foundation
import SwiftData

struct FoodLibraryLoader {
    struct FoodSeed: Codable { let name: String; let brand: String?; let servingSize: String; let calories: Double; let proteinG: Double; let carbsG: Double; let fatG: Double; let barcode: String?; let isFavorite: Bool }
    static func loadBundledFoods(context: ModelContext) {
        guard let url = Bundle.main.url(forResource: "food_library", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let items = try JSONDecoder().decode([FoodSeed].self, from: data)
            for i in items {
                let item = FoodItem(name: i.name, brand: i.brand, servingSize: i.servingSize, calories: i.calories, proteinG: i.proteinG, carbsG: i.carbsG, fatG: i.fatG, barcode: i.barcode, isFavorite: i.isFavorite, isUserCreated: false)
                context.insert(item)
            }
            try context.save()
        } catch { print("Failed to load food library: \(error)") }
    }
}
