import Foundation

struct TrainingProgram {
    static let totalWeeks = 12

    static func phase(for week: Int) -> String {
        switch week {
        case 1...4: return "Foundation"
        case 5...8: return "Build"
        case 9...11: return "Strength"
        default: return "Deload"
        }
    }

    static func guidance(for week: Int) -> String {
        switch week {
        case 1...4:
            return "Learn the movements and finish each set with about 2–3 good reps still available."
        case 5...8:
            return "Add weight gradually while maintaining control and leaving about 1–2 reps in reserve."
        case 9...11:
            return "Use challenging, repeatable weights. Do not sacrifice form to complete a prescribed rep."
        default:
            return "Reduce your usual working weight by roughly 20–30% and focus on smooth technique."
        }
    }

    static func workouts(for week: Int) -> [ProgramWorkout] {
        let prescription = prescriptionForWeek(week)

        return [
            ProgramWorkout(
                week: week,
                day: 1,
                title: "Workout A",
                focus: "Squat · Push · Pull",
                exercises: [
                    plan("Back Squat", "Legs", prescription.compoundSets, prescription.compoundReps, prescription.compoundDisplay),
                    plan("Bench Press", "Chest", prescription.compoundSets, prescription.compoundReps, prescription.compoundDisplay),
                    plan("Seated Cable Row", "Back", prescription.accessorySets, prescription.accessoryReps, prescription.accessoryDisplay),
                    plan("Walking Lunge", "Legs", prescription.accessorySets, prescription.accessoryReps, prescription.accessoryDisplay),
                    plan("Plank", "Core", prescription.coreSets, 30, "30–45 sec")
                ]
            ),
            ProgramWorkout(
                week: week,
                day: 2,
                title: "Workout B",
                focus: "Hinge · Overhead · Back",
                exercises: [
                    plan("Romanian Deadlift", "Legs", prescription.compoundSets, prescription.compoundReps, prescription.compoundDisplay),
                    plan("Overhead Press", "Shoulders", prescription.compoundSets, prescription.compoundReps, prescription.compoundDisplay),
                    plan("Lat Pulldown", "Back", prescription.accessorySets, prescription.accessoryReps, prescription.accessoryDisplay),
                    plan("Hip Thrust", "Glutes", prescription.accessorySets, prescription.accessoryReps, prescription.accessoryDisplay),
                    plan("Cable Crunch", "Core", prescription.coreSets, prescription.coreReps, prescription.coreDisplay)
                ]
            ),
            ProgramWorkout(
                week: week,
                day: 3,
                title: "Workout C",
                focus: "Full Body · Accessories",
                exercises: [
                    plan("Leg Press", "Legs", prescription.compoundSets, prescription.compoundReps, prescription.compoundDisplay),
                    plan("Incline Dumbbell Press", "Chest", prescription.compoundSets, prescription.compoundReps, prescription.compoundDisplay),
                    plan("Barbell Row", "Back", prescription.compoundSets, prescription.compoundReps, prescription.compoundDisplay),
                    plan("Lateral Raise", "Shoulders", prescription.accessorySets, prescription.accessoryReps, prescription.accessoryDisplay),
                    plan("Biceps Curl", "Arms", prescription.armSets, prescription.armReps, prescription.armDisplay),
                    plan("Triceps Pushdown", "Arms", prescription.armSets, prescription.armReps, prescription.armDisplay)
                ]
            )
        ]
    }

    private static func plan(
        _ name: String,
        _ muscleGroup: String,
        _ sets: Int,
        _ reps: Int,
        _ display: String
    ) -> PlannedExercise {
        PlannedExercise(
            exercise: Exercise(name: name, muscleGroup: muscleGroup),
            setCount: sets,
            targetReps: reps,
            repDisplay: display
        )
    }

    private static func prescriptionForWeek(_ week: Int) -> Prescription {
        switch week {
        case 1...2:
            return Prescription(compoundSets: 3, compoundReps: 8, compoundDisplay: "8–10", accessorySets: 2, accessoryReps: 10, accessoryDisplay: "10–12", coreSets: 2, coreReps: 12, coreDisplay: "12–15", armSets: 2, armReps: 10, armDisplay: "10–12")
        case 3...4:
            return Prescription(compoundSets: 3, compoundReps: 8, compoundDisplay: "8–10", accessorySets: 3, accessoryReps: 10, accessoryDisplay: "10–12", coreSets: 3, coreReps: 12, coreDisplay: "12–15", armSets: 3, armReps: 10, armDisplay: "10–12")
        case 5...6:
            return Prescription(compoundSets: 4, compoundReps: 6, compoundDisplay: "6–8", accessorySets: 3, accessoryReps: 8, accessoryDisplay: "8–10", coreSets: 3, coreReps: 12, coreDisplay: "12–15", armSets: 3, armReps: 10, armDisplay: "10–12")
        case 7...8:
            return Prescription(compoundSets: 4, compoundReps: 6, compoundDisplay: "6–8", accessorySets: 3, accessoryReps: 8, accessoryDisplay: "8–10", coreSets: 3, coreReps: 12, coreDisplay: "12–15", armSets: 3, armReps: 8, armDisplay: "8–10")
        case 9...11:
            return Prescription(compoundSets: 4, compoundReps: 5, compoundDisplay: "5–6", accessorySets: 3, accessoryReps: 8, accessoryDisplay: "8–10", coreSets: 3, coreReps: 10, coreDisplay: "10–12", armSets: 3, armReps: 8, armDisplay: "8–10")
        default:
            return Prescription(compoundSets: 2, compoundReps: 8, compoundDisplay: "8 easy", accessorySets: 2, accessoryReps: 10, accessoryDisplay: "10 easy", coreSets: 2, coreReps: 10, coreDisplay: "10 easy", armSets: 2, armReps: 10, armDisplay: "10 easy")
        }
    }

    private struct Prescription {
        let compoundSets: Int
        let compoundReps: Int
        let compoundDisplay: String
        let accessorySets: Int
        let accessoryReps: Int
        let accessoryDisplay: String
        let coreSets: Int
        let coreReps: Int
        let coreDisplay: String
        let armSets: Int
        let armReps: Int
        let armDisplay: String
    }
}
