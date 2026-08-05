import SwiftUI

struct ExercisePickerView: View {
    @EnvironmentObject private var store: WorkoutStore
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedExercises: [Exercise]
    @State private var searchText = ""

    private var filteredExercises: [Exercise] {
        guard !searchText.isEmpty else { return store.exerciseLibrary }
        return store.exerciseLibrary.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.muscleGroup.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var grouped: [(String, [Exercise])] {
        Dictionary(grouping: filteredExercises, by: \.muscleGroup)
            .map { ($0.key, $0.value.sorted { $0.name < $1.name }) }
            .sorted { $0.0 < $1.0 }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(grouped, id: \.0) { group, exercises in
                    Section(group) {
                        ForEach(exercises) { exercise in
                            Button {
                                toggle(exercise)
                            } label: {
                                HStack {
                                    Text(exercise.name).foregroundStyle(.primary)
                                    Spacer()
                                    if selectedExercises.contains(exercise) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.tint)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search exercises")
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func toggle(_ exercise: Exercise) {
        if let index = selectedExercises.firstIndex(of: exercise) {
            selectedExercises.remove(at: index)
        } else {
            selectedExercises.append(exercise)
        }
    }
}
