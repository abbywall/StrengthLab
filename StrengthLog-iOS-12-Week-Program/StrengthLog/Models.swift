import Foundation

enum ProgramType: String, Codable, CaseIterable, Identifiable {
    case rockClimbing
    case mountaineering
    case trailRunning

    var id: String { rawValue }

    var title: String {
        switch self {
        case .rockClimbing: return "Rock Climbing"
        case .mountaineering: return "Mountaineering"
        case .trailRunning: return "Trail Running"
        }
    }

    var subtitle: String {
        switch self {
        case .rockClimbing: return "Pulling strength, grip endurance, shoulders, and core"
        case .mountaineering: return "Uphill strength, loaded carries, durability, and stability"
        case .trailRunning: return "Single-leg strength, downhill resilience, hips, and calves"
        }
    }

    var icon: String {
        switch self {
        case .rockClimbing: return "figure.climbing"
        case .mountaineering: return "mountain.2.fill"
        case .trailRunning: return "figure.run"
        }
    }
}

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
    var programType: ProgramType?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        exercises: [WorkoutExercise],
        durationSeconds: Int = 0,
        programWeek: Int? = nil,
        programDay: Int? = nil,
        programType: ProgramType? = nil
    ) {
        self.id = id
        self.date = date
        self.exercises = exercises
        self.durationSeconds = durationSeconds
        self.programWeek = programWeek
        self.programDay = programDay
        self.programType = programType
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
    let programType: ProgramType
    let week: Int
    let day: Int
    let title: String
    let focus: String
    let exercises: [PlannedExercise]

    var id: String { "\(programType.rawValue)-week-\(week)-day-\(day)" }
}
