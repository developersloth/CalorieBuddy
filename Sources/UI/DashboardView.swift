import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var vm = DashboardVM(context: ModelContext(sharedContainer))

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ProgressView(value: Double(vm.todayCalories), total: Double(max(vm.dailyTarget, 1))) { Text("Today's Calories") } currentValueLabel: { Text("\(vm.todayCalories) / \(vm.dailyTarget) kcal") }
                    .progressViewStyle(.circular)
                    .tint(.blue)
                    .padding(.top, 8)

                HStack(spacing: 16) {
                    Text("Intake: \(vm.todayCalories) kcal")
                    Text("Burned: \(vm.todayBurned) kcal")
                    Text("Net: \(vm.netCalories) kcal")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)

                HStack {
                    NavigationLink("Add Food") { AddFoodView() }
                    Spacer()
                    NavigationLink("Scan Barcode") { BarcodeScannerView() }
                    Spacer()
                    NavigationLink("Scan Label") { NutritionLabelOCRView() }
                    Spacer()
                    NavigationLink("Add Activity") { AddActivityView() }
                }
                .padding(.horizontal)

                // Today food log
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today").font(.headline).padding(.horizontal)
                    ForEach(vm.todayLogs, id: \.id) { log in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(log.food.name).font(.subheadline)
                                Text("\(log.servings, specifier: "%.2f") Ã— \(log.food.servingSize)").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(Int(log.calories)) kcal").foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        Divider().padding(.horizontal)
                    }
                }

                // Weekly chart
                VStack(alignment: .leading) {
                    Text("Last 7 Days").font(.headline).padding(.horizontal)
                    Chart {
                        ForEach(vm.weekSeries, id: \.0) { (date, cals) in
                            BarMark(x: .value("Day", date, unit: .day), y: .value("Calories", cals))
                        }
                    }
                    .frame(height: 200)
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Calorie Buddy")
        .onAppear { let newVM = DashboardVM(context: context); _vm.wrappedValue = newVM; vm.reloadAll() }
    }
}
