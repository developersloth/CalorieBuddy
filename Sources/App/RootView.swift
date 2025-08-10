import SwiftUI
import SwiftData

struct RootView: View {
    @Query private var profiles: [UserProfile]
    var body: some View { profiles.first != nil ? AnyView(DashboardView()) : AnyView(OnboardingView()) }
}
