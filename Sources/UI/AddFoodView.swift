import SwiftUI
import SwiftData

struct AddFoodView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var vm = AddFoodVM(context: ModelContext(sharedContainer))

    var body: some View {
        VStack {
            HStack {
                TextField("Search foods...", text: $vm.query)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: vm.query) { _ in vm.search() }
                Stepper(value: $vm.servings, in: 0.25...10, step: 0.25) { Text("\(vm.servings, specifier: "%.2f")Ã—") }.frame(width: 120)
            }.padding()

            List(vm.results, id: \.id) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name).font(.headline)
                        Text(item.servingSize).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(Int(item.calories)) kcal")
                        Text("P \(item.proteinG, specifier: "%.0f")  C \(item.carbsG, specifier: "%.0f")  F \(item.fatG, specifier: "%.0f")").font(.caption).foregroundStyle(.secondary)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { vm.addLog(for: item) }
            }
        }
        .navigationTitle("Add Food")
        .onAppear { _vm.wrappedValue = AddFoodVM(context: context) }
        .toolbar { NavigationLink("Custom") { CreateCustomFoodView(onSave: { name, size, cals, p, c, f in vm.createCustomFood(name: name, servingSize: size, calories: cals, protein: p, carbs: c, fat: f); vm.search() }) } }
    }
}

struct CreateCustomFoodView: View {
    var onSave: (String, String, Double, Double, Double, Double) -> Void
    @State private var name = ""; @State private var size = "100g"; @State private var calories = 0.0; @State private var protein = 0.0; @State private var carbs = 0.0; @State private var fat = 0.0
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Serving size", text: $size)
            HStack { Text("Calories"); Spacer(); TextField("kcal", value: $calories, format: .number).multilineTextAlignment(.trailing).keyboardType(.decimalPad) }
            HStack { Text("Protein (g)"); Spacer(); TextField("g", value: $protein, format: .number).multilineTextAlignment(.trailing).keyboardType(.decimalPad) }
            HStack { Text("Carbs (g)"); Spacer(); TextField("g", value: $carbs, format: .number).multilineTextAlignment(.trailing).keyboardType(.decimalPad) }
            HStack { Text("Fat (g)"); Spacer(); TextField("g", value: $fat, format: .number).multilineTextAlignment(.trailing).keyboardType(.decimalPad) }
        }
        .navigationTitle("Custom Food")
        .toolbar { Button("Save") { guard !name.isEmpty else { return }; onSave(name, size, calories, protein, carbs, fat) } }
    }
}
