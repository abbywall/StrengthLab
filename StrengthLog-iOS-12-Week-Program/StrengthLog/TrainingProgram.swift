import Foundation

struct TrainingProgram {
    static let totalWeeks = 12

    static func phase(for week: Int) -> String {
        switch week {
        case 1...3: return "Foundation"
        case 4...7: return "Build"
        case 8...11: return "Specific Strength"
        default: return "Deload & Test"
        }
    }

    static func guidance(for week: Int, type: ProgramType) -> String {
        let effort: String
        switch week {
        case 1...3: effort = "Use controlled technique and finish with 2–3 reps in reserve."
        case 4...7: effort = "Add load gradually while keeping 1–2 reps in reserve."
        case 8...11: effort = "Use challenging, repeatable loads without sacrificing form."
        default: effort = "Reduce load by 25–35% and move smoothly."
        }

        switch type {
        case .rockClimbing:
            return "Prioritize healthy shoulders and quality pulling. Avoid maximal finger loading in the weight room. \(effort)"
        case .mountaineering:
            return "Emphasize steady leg strength and trunk control under load. \(effort)"
        case .trailRunning:
            return "Prioritize single-leg control and slow eccentric lowering for downhill durability. \(effort)"
        }
    }

    static func workouts(for week: Int, type: ProgramType) -> [ProgramWorkout] {
        let p = prescription(for: week)
        switch type {
        case .rockClimbing: return climbingWorkouts(week: week, p: p)
        case .mountaineering: return mountaineeringWorkouts(week: week, p: p)
        case .trailRunning: return trailRunningWorkouts(week: week, p: p)
        }
    }

    private static func climbingWorkouts(week: Int, p: Prescription) -> [ProgramWorkout] {
        [
            workout(.rockClimbing, week, 1, "Pull Strength", "Back · Grip · Core", [
                plan("Assisted Pull-Up", "Back", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Single-Arm Dumbbell Row", "Back", p.accessorySets, p.accessoryReps, p.accessoryDisplay),
                plan("Romanian Deadlift", "Posterior Chain", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Farmer Carry", "Grip", p.carrySets, 30, "30–45 sec"),
                plan("Hanging Knee Raise", "Core", p.coreSets, p.coreReps, p.coreDisplay)
            ]),
            workout(.rockClimbing, week, 2, "Shoulder Balance", "Push · Scapular Control · Legs", [
                plan("Incline Dumbbell Press", "Chest", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Half-Kneeling Landmine Press", "Shoulders", p.accessorySets, p.accessoryReps, p.accessoryDisplay),
                plan("Face Pull", "Shoulders", p.accessorySets, p.accessoryReps + 2, "12–15"),
                plan("Bulgarian Split Squat", "Legs", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Side Plank", "Core", p.coreSets, 30, "30–45 sec/side")
            ]),
            workout(.rockClimbing, week, 3, "Power Endurance", "Full Body · Antagonists", [
                plan("Lat Pulldown", "Back", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Push-Up", "Chest", p.accessorySets, p.accessoryReps, p.accessoryDisplay),
                plan("Step-Up", "Legs", p.accessorySets, p.accessoryReps, p.accessoryDisplay),
                plan("Reverse Wrist Curl", "Forearms", p.accessorySets, p.accessoryReps + 2, "12–15"),
                plan("Pallof Press", "Core", p.coreSets, p.coreReps, p.coreDisplay)
            ])
        ]
    }

    private static func mountaineeringWorkouts(week: Int, p: Prescription) -> [ProgramWorkout] {
        [
            workout(.mountaineering, week, 1, "Uphill Strength", "Quads · Glutes · Calves", [
                plan("Front Squat", "Legs", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Weighted Step-Up", "Legs", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Romanian Deadlift", "Posterior Chain", p.accessorySets, p.accessoryReps, p.accessoryDisplay),
                plan("Standing Calf Raise", "Calves", p.accessorySets, p.accessoryReps + 2, "12–15"),
                plan("Dead Bug", "Core", p.coreSets, p.coreReps, p.coreDisplay)
            ]),
            workout(.mountaineering, week, 2, "Loaded Movement", "Carries · Back · Trunk", [
                plan("Walking Lunge", "Legs", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Seated Cable Row", "Back", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Overhead Press", "Shoulders", p.accessorySets, p.accessoryReps, p.accessoryDisplay),
                plan("Farmer Carry", "Grip & Core", p.carrySets, 40, "40–60 sec"),
                plan("Pallof Press", "Core", p.coreSets, p.coreReps, p.coreDisplay)
            ]),
            workout(.mountaineering, week, 3, "Mountain Durability", "Single Leg · Posterior Chain", [
                plan("Bulgarian Split Squat", "Legs", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Hip Thrust", "Glutes", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Lat Pulldown", "Back", p.accessorySets, p.accessoryReps, p.accessoryDisplay),
                plan("Tibialis Raise", "Lower Legs", p.accessorySets, p.accessoryReps + 2, "12–15"),
                plan("Plank", "Core", p.coreSets, 40, "40–60 sec")
            ])
        ]
    }

    private static func trailRunningWorkouts(week: Int, p: Prescription) -> [ProgramWorkout] {
        [
            workout(.trailRunning, week, 1, "Single-Leg Strength", "Hips · Quads · Stability", [
                plan("Bulgarian Split Squat", "Legs", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Single-Leg Romanian Deadlift", "Posterior Chain", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Lateral Step-Down", "Legs", p.accessorySets, p.accessoryReps, p.accessoryDisplay),
                plan("Standing Calf Raise", "Calves", p.accessorySets, p.accessoryReps + 2, "12–15"),
                plan("Side Plank", "Core", p.coreSets, 30, "30–45 sec/side")
            ]),
            workout(.trailRunning, week, 2, "Posterior Chain", "Glutes · Hamstrings · Core", [
                plan("Romanian Deadlift", "Posterior Chain", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Hip Thrust", "Glutes", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Reverse Lunge", "Legs", p.accessorySets, p.accessoryReps, p.accessoryDisplay),
                plan("Seated Calf Raise", "Calves", p.accessorySets, p.accessoryReps + 2, "12–15"),
                plan("Dead Bug", "Core", p.coreSets, p.coreReps, p.coreDisplay)
            ]),
            workout(.trailRunning, week, 3, "Downhill Durability", "Eccentric Quads · Lower Legs", [
                plan("Goblet Squat", "Legs", p.mainSets, p.mainReps, p.mainDisplay),
                plan("Slow Step-Down", "Legs", p.mainSets, p.mainReps, "6–8 slow/side"),
                plan("Walking Lunge", "Legs", p.accessorySets, p.accessoryReps, p.accessoryDisplay),
                plan("Tibialis Raise", "Lower Legs", p.accessorySets, p.accessoryReps + 2, "12–15"),
                plan("Pallof Press", "Core", p.coreSets, p.coreReps, p.coreDisplay)
            ])
        ]
    }

    private static func workout(_ type: ProgramType, _ week: Int, _ day: Int, _ title: String, _ focus: String, _ exercises: [PlannedExercise]) -> ProgramWorkout {
        ProgramWorkout(programType: type, week: week, day: day, title: title, focus: focus, exercises: exercises)
    }

    private static func plan(_ name: String, _ group: String, _ sets: Int, _ reps: Int, _ display: String) -> PlannedExercise {
        PlannedExercise(exercise: Exercise(name: name, muscleGroup: group), setCount: sets, targetReps: reps, repDisplay: display)
    }

    private static func prescription(for week: Int) -> Prescription {
        switch week {
        case 1...3: return Prescription(mainSets: 3, mainReps: 8, mainDisplay: "8–10", accessorySets: 2, accessoryReps: 10, accessoryDisplay: "10–12", coreSets: 2, coreReps: 10, coreDisplay: "10–12", carrySets: 3)
        case 4...7: return Prescription(mainSets: 4, mainReps: 6, mainDisplay: "6–8", accessorySets: 3, accessoryReps: 10, accessoryDisplay: "10–12", coreSets: 3, coreReps: 10, coreDisplay: "10–12", carrySets: 4)
        case 8...11: return Prescription(mainSets: 4, mainReps: 5, mainDisplay: "5–6", accessorySets: 3, accessoryReps: 8, accessoryDisplay: "8–10", coreSets: 3, coreReps: 10, coreDisplay: "10–12", carrySets: 4)
        default: return Prescription(mainSets: 2, mainReps: 8, mainDisplay: "8 easy", accessorySets: 2, accessoryReps: 10, accessoryDisplay: "10 easy", coreSets: 2, coreReps: 10, coreDisplay: "10 easy", carrySets: 2)
        }
    }

    private struct Prescription {
        let mainSets: Int; let mainReps: Int; let mainDisplay: String
        let accessorySets: Int; let accessoryReps: Int; let accessoryDisplay: String
        let coreSets: Int; let coreReps: Int; let coreDisplay: String
        let carrySets: Int
    }
}
