import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let muscleGroup: String

    init(id: UUID = UUID(), name: String, muscleGroup: String) {
        self.id = id
        self.name = name
        self.muscleGroup = muscleGroup
    }
}

struct LoggedSet: Identifiable, Codable, Hashable {
    let id: UUID
    var weight: Double
    var reps: Int
    var completed: Bool

    init(id: UUID = UUID(), weight: Double = 0, reps: Int = 8, completed: Bool = false) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.completed = completed
    }
}

struct WorkoutExercise: Identifiable, Codable, Hashable {
    let id: UUID
    let exercise: Exercise
    var sets: [LoggedSet]

    init(id: UUID = UUID(), exercise: Exercise, sets: [LoggedSet] = [LoggedSet()]) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
    }
}

struct Workout: Identifiable, Codable, Hashable {
    let id: UUID
    var date: Date
    var exercises: [WorkoutExercise]
    var durationSeconds: Int
    var programWeek: Int?
    var programDay: Int?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        exercises: [WorkoutExercise],
        durationSeconds: Int = 0,
        programWeek: Int? = nil,
        programDay: Int? = nil
    ) {
        self.id = id
        self.date = date
        self.exercises = exercises
        self.durationSeconds = durationSeconds
        self.programWeek = programWeek
        self.programDay = programDay
    }
}

struct PlannedExercise: Identifiable, Hashable {
    let id = UUID()
    let exercise: Exercise
    let setCount: Int
    let targetReps: Int
    let repDisplay: String

    init(exercise: Exercise, setCount: Int, targetReps: Int, repDisplay: String? = nil) {
        self.exercise = exercise
        self.setCount = setCount
        self.targetReps = targetReps
        self.repDisplay = repDisplay ?? "\(targetReps)"
    }
}

struct ProgramWorkout: Identifiable, Hashable {
    let week: Int
    let day: Int
    let title: String
    let focus: String
    let exercises: [PlannedExercise]

    var id: String { "week-\(week)-day-\(day)" }
}
