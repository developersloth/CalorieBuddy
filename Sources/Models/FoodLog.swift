import Foundation
import SwiftData

@Model
final class FoodLog {
    var id: UUID = UUID()
    var date: Date
    @Relationship var food: FoodItem
    var servings: Double

    init(date: Date, food: FoodItem, servings: Double) {
        self.date = date.stripTimeToLocalDay()
        self.food = food
        self.servings = servings
    }

    var calories: Double { food.calories * servings }
    var proteinG: Double { food.proteinG * servings }
    var carbsG: Double { food.carbsG * servings }
    var fatG: Double { food.fatG * servings }
}
