import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var vm = OnboardingVM()

    var body: some View {
        Form {
            Section("About You") {
                TextField("Name", text: $vm.name)
                Picker("Sex", selection: $vm.sex) { ForEach(UserProfile.Sex.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) } }
                DatePicker("Birth Date", selection: $vm.birthDate, displayedComponents: .date)
                Picker("Units", selection: $vm.units) {
                    Text("Metric").tag(UserProfile.Units.metric)
                    Text("Imperial").tag(UserProfile.Units.imperial)
                }
                HStack { Text("Height (\(vm.units == .metric ? "cm" : "in"))"); Spacer(); TextField("Height", value: $vm.height, format: .number).keyboardType(.decimalPad).multilineTextAlignment(.trailing) }
                HStack { Text("Weight (\(vm.units == .metric ? "kg" : "lb"))"); Spacer(); TextField("Weight", value: $vm.weight, format: .number).keyboardType(.decimalPad).multilineTextAlignment(.trailing) }
                Picker("Activity", selection: $vm.activity) { ForEach(UserProfile.ActivityLevel.allCases, id: \.self) { Text($0.rawValue).tag($0) } }
                Toggle("iCloud Sync (later)", isOn: $vm.syncICloud)
            }
            Button("Continue") { try? vm.createProfile(context: context) }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Welcome")
    }
}
