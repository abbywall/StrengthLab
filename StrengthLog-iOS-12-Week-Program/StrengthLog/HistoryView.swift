import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var store: WorkoutStore

    var body: some View {
        NavigationStack {
            Group {
                if store.workoutHistory.isEmpty {
                    ContentUnavailableView(
                        "No Workouts Yet",
                        systemImage: "calendar.badge.clock",
                        description: Text("Completed workouts will appear here.")
                    )
                } else {
                    List {
                        ForEach(store.workoutHistory) { workout in
                            NavigationLink {
                                WorkoutDetailView(workout: workout)
                            } label: {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.headline)
                                    Text("\(workout.exercises.count) exercises • \(completedSets(workout)) sets • \(duration(workout.durationSeconds))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete { store.workoutHistory.remove(atOffsets: $0) }
                    }
                }
            }
            .navigationTitle("History")
        }
    }

    private func completedSets(_ workout: Workout) -> Int {
        workout.exercises.flatMap(\.sets).filter(\.completed).count
    }

    private func duration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        return minutes < 60 ? "\(minutes) min" : "\(minutes / 60)h \(minutes % 60)m"
    }
}

private struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        List {
            ForEach(workout.exercises) { item in
                Section(item.exercise.name) {
                    ForEach(Array(item.sets.enumerated()), id: \.element.id) { index, set in
                        HStack {
                            Text("Set \(index + 1)")
                            Spacer()
                            Text("\(set.weight, specifier: "%.1f") lb × \(set.reps)")
                            Image(systemName: set.completed ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(set.completed ? .green : .secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(workout.date.formatted(date: .abbreviated, time: .omitted))
    }
}
