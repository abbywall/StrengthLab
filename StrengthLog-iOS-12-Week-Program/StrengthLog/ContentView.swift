import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ProgramView()
                .tabItem { Label("Program", systemImage: "calendar") }

            StartWorkoutView()
                .tabItem { Label("Workout", systemImage: "dumbbell.fill") }

            HistoryView()
                .tabItem { Label("History", systemImage: "clock.arrow.circlepath") }
        }
    }
}
