import Foundation
import SwiftData

@MainActor
final class AddFoodVM: ObservableObject {
    @Published var query: String = ""
    @Published var results: [FoodItem] = []
    @Published var servings: Double = 1.0

    let context: ModelContext

    init(context: ModelContext) { self.context = context; search() }

    func search() {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            results = (try? context.fetch(FetchDescriptor<FoodItem>())) ?? []
        } else {
            let q = query.lowercased()
            let pred = #Predicate<FoodItem> { $0.name.lowercased().contains(q) || ($0.brand?.lowercased().contains(q) ?? false) }
            results = (try? context.fetch(FetchDescriptor<FoodItem>(predicate: pred))) ?? []
        }
    }
    func addLog(for food: FoodItem, date: Date = .now) { let log = FoodLog(date: date, food: food, servings: servings); context.insert(log); try? context.save() }
    func createCustomFood(name: String, servingSize: String, calories: Double, protein: Double, carbs: Double, fat: Double) {
        let item = FoodItem(name: name, servingSize: servingSize, calories: calories, proteinG: protein, carbsG: carbs, fatG: fat, isUserCreated: true)
        context.insert(item); try? context.save()
    }
}
