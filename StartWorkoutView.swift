import SwiftUI

struct StartWorkoutView: View {
    @EnvironmentObject private var store: WorkoutStore
    @State private var selectedExercises: [Exercise] = []
    @State private var showingPicker = false
    @State private var activeWorkout = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if selectedExercises.isEmpty {
                    ContentUnavailableView(
                        "Build Your Workout",
                        systemImage: "dumbbell",
                        description: Text("Choose one or more exercises to begin logging sets and reps.")
                    )
                } else {
                    List {
                        ForEach(selectedExercises) { exercise in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(exercise.name).font(.headline)
                                    Text(exercise.muscleGroup).font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "line.3.horizontal")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete { selectedExercises.remove(atOffsets: $0) }
                    }
                    .listStyle(.plain)
                }

                VStack(spacing: 12) {
                    Button {
                        showingPicker = true
                    } label: {
                        Label("Select Exercises", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)

                    Button {
                        activeWorkout = true
                    } label: {
                        Text("Start Workout")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(selectedExercises.isEmpty)
                }
                .padding()
            }
            .navigationTitle("StrengthLog")
            .sheet(isPresented: $showingPicker) {
                ExercisePickerView(selectedExercises: $selectedExercises)
                    .environmentObject(store)
            }
            .fullScreenCover(isPresented: $activeWorkout) {
                WorkoutSessionView(exercises: selectedExercises) {
                    selectedExercises.removeAll()
                    activeWorkout = false
                }
                .environmentObject(store)
            }
        }
    }
}
