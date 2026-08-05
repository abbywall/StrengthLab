import Foundation

@MainActor
final class WorkoutStore: ObservableObject {
    @Published var workoutHistory: [Workout] = [] {
        didSet { save() }
    }

    let exerciseLibrary: [Exercise] = [
        Exercise(name: "Back Squat", muscleGroup: "Legs"),
        Exercise(name: "Romanian Deadlift", muscleGroup: "Legs"),
        Exercise(name: "Leg Press", muscleGroup: "Legs"),
        Exercise(name: "Walking Lunge", muscleGroup: "Legs"),
        Exercise(name: "Hip Thrust", muscleGroup: "Glutes"),
        Exercise(name: "Bench Press", muscleGroup: "Chest"),
        Exercise(name: "Incline Dumbbell Press", muscleGroup: "Chest"),
        Exercise(name: "Push-Up", muscleGroup: "Chest"),
        Exercise(name: "Overhead Press", muscleGroup: "Shoulders"),
        Exercise(name: "Lateral Raise", muscleGroup: "Shoulders"),
        Exercise(name: "Lat Pulldown", muscleGroup: "Back"),
        Exercise(name: "Seated Cable Row", muscleGroup: "Back"),
        Exercise(name: "Barbell Row", muscleGroup: "Back"),
        Exercise(name: "Assisted Pull-Up", muscleGroup: "Back"),
        Exercise(name: "Biceps Curl", muscleGroup: "Arms"),
        Exercise(name: "Triceps Pushdown", muscleGroup: "Arms"),
        Exercise(name: "Plank", muscleGroup: "Core"),
        Exercise(name: "Cable Crunch", muscleGroup: "Core")
    ]

    private let storageKey = "strengthLog.workoutHistory"

    init() {
        load()
    }

    func saveWorkout(_ workout: Workout) {
        workoutHistory.insert(workout, at: 0)
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(workoutHistory) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Workout].self, from: data) else { return }
        workoutHistory = decoded
    }
}
