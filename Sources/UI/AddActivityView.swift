import SwiftUI
import SwiftData

struct AddActivityView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var vm = AddActivityVM(context: ModelContext(sharedContainer))

    var body: some View {
        VStack {
            HStack {
                TextField("Search activities...", text: $vm.query)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: vm.query) { _ in vm.search() }
                Stepper(value: $vm.minutes, in: 5...300, step: 5) { Text("\(vm.minutes) min") }.frame(width: 140)
            }.padding()

            List(vm.results, id: \.id) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name).font(.headline)
                        Text("\(item.category.rawValue.capitalized) â€¢ \(item.met, specifier: "%.1f") MET").font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    let weightKg = (try? context.fetch(FetchDescriptor<UserProfile>()).first?.weightKg) ?? 70
                    Text("\(ActivityEnergyCalculator.calories(met: item.met, weightKg: weightKg, minutes: vm.minutes)) kcal").foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
                .onTapGesture { vm.addLog(for: item) }
            }
        }
        .navigationTitle("Add Activity")
        .onAppear { _vm.wrappedValue = AddActivityVM(context: context) }
    }
}
