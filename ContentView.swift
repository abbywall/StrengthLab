import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            StartWorkoutView()
                .tabItem { Label("Workout", systemImage: "dumbbell.fill") }

            HistoryView()
                .tabItem { Label("History", systemImage: "clock.arrow.circlepath") }
        }
    }
}
