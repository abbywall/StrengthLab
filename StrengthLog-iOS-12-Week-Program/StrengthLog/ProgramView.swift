import SwiftUI

struct ProgramView: View {
    @EnvironmentObject private var store: WorkoutStore
    @State private var selectedWeek = 1
    @State private var activeWorkout: ProgramWorkout?

    private var workouts: [ProgramWorkout] {
        TrainingProgram.workouts(for: selectedWeek)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("12-Week Strength Program")
                                    .font(.title2.bold())
                                Text("Three full-body workouts each week")
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "calendar.badge.checkmark")
                                .font(.largeTitle)
                                .foregroundStyle(.tint)
                        }

                        ProgressView(value: Double(completedCount), total: 36)
                        Text("\(completedCount) of 36 workouts completed")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }

                Section("Choose Week") {
                    Picker("Week", selection: $selectedWeek) {
                        ForEach(1...TrainingProgram.totalWeeks, id: \.self) { week in
                            Text("Week \(week)").tag(week)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(TrainingProgram.phase(for: selectedWeek))
                            .font(.headline)
                        Text(TrainingProgram.guidance(for: selectedWeek))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Week \(selectedWeek) Focus")
                }

                Section("Training Days") {
                    ForEach(workouts) { workout in
                        NavigationLink {
                            ProgramWorkoutDetailView(
                                workout: workout,
                                isCompleted: isCompleted(workout),
                                onStart: { activeWorkout = workout }
                            )
                        } label: {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(isCompleted(workout) ? Color.green.opacity(0.15) : Color.accentColor.opacity(0.12))
                                        .frame(width: 42, height: 42)
                                    Image(systemName: isCompleted(workout) ? "checkmark" : "\(workout.day).circle.fill")
                                        .foregroundStyle(isCompleted(workout) ? .green : .tint)
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(workout.title).font(.headline)
                                    Text(workout.focus)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text("\(workout.exercises.count) exercises")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Suggested Schedule") {
                    Label("Monday · Workout A", systemImage: "1.circle")
                    Label("Wednesday · Workout B", systemImage: "2.circle")
                    Label("Friday · Workout C", systemImage: "3.circle")
                    Text("Keep at least one recovery day between sessions whenever possible.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Program")
            .fullScreenCover(item: $activeWorkout) { workout in
                WorkoutSessionView(
                    plannedExercises: workout.exercises,
                    programWeek: workout.week,
                    programDay: workout.day
                ) {
                    activeWorkout = nil
                }
                .environmentObject(store)
            }
        }
    }

    private var completedCount: Int {
        Set(store.workoutHistory.compactMap { workout -> String? in
            guard let week = workout.programWeek, let day = workout.programDay else { return nil }
            return "\(week)-\(day)"
        }).count
    }

    private func isCompleted(_ workout: ProgramWorkout) -> Bool {
        store.workoutHistory.contains {
            $0.programWeek == workout.week && $0.programDay == workout.day
        }
    }
}

private struct ProgramWorkoutDetailView: View {
    let workout: ProgramWorkout
    let isCompleted: Bool
    let onStart: () -> Void

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(workout.focus)
                        .font(.title3.bold())
                    Text("Week \(workout.week) · Day \(workout.day)")
                        .foregroundStyle(.secondary)
                    if isCompleted {
                        Label("Completed", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.vertical, 4)
            }

            Section("Exercises") {
                ForEach(workout.exercises) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(item.exercise.name).font(.headline)
                            Text(item.exercise.muscleGroup)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(item.setCount) × \(item.repDisplay)")
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 3)
                }
            }

            Section {
                Button(action: onStart) {
                    Label(isCompleted ? "Repeat Workout" : "Start Workout", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(workout.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
