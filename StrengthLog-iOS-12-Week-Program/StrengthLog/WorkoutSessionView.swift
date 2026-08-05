import SwiftUI
import Combine
import UIKit

struct WorkoutSessionView: View {
    @EnvironmentObject private var store: WorkoutStore
    @Environment(\.dismiss) private var dismiss

    @State private var workoutExercises: [WorkoutExercise]
    @State private var restDuration = 90
    @State private var remainingRest = 0
    @State private var timerRunning = false
    @State private var startDate = Date()
    @State private var showingFinishAlert = false

    private let programWeek: Int?
    private let programDay: Int?
    let onFinish: () -> Void
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(exercises: [Exercise], onFinish: @escaping () -> Void) {
        _workoutExercises = State(initialValue: exercises.map { WorkoutExercise(exercise: $0) })
        self.programWeek = nil
        self.programDay = nil
        self.onFinish = onFinish
    }

    init(
        plannedExercises: [PlannedExercise],
        programWeek: Int,
        programDay: Int,
        onFinish: @escaping () -> Void
    ) {
        _workoutExercises = State(initialValue: plannedExercises.map { planned in
            WorkoutExercise(
                exercise: planned.exercise,
                sets: (0..<planned.setCount).map { _ in
                    LoggedSet(reps: planned.targetReps)
                }
            )
        })
        self.programWeek = programWeek
        self.programDay = programDay
        self.onFinish = onFinish
    }

    var body: some View {
        NavigationStack {
            List {
                if timerRunning || remainingRest > 0 {
                    Section {
                        RestTimerCard(
                            remaining: remainingRest,
                            duration: restDuration,
                            isRunning: timerRunning,
                            onPauseResume: { timerRunning.toggle() },
                            onSkip: { stopTimer() }
                        )
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                ForEach($workoutExercises) { $workoutExercise in
                    Section {
                        ForEach($workoutExercise.sets) { $set in
                            SetRow(setNumber: setNumber(for: set.id, in: workoutExercise), set: $set) {
                                if set.completed {
                                    startRestTimer()
                                }
                            }
                        }
                        .onDelete { workoutExercise.sets.remove(atOffsets: $0) }

                        Button {
                            let previous = workoutExercise.sets.last
                            workoutExercise.sets.append(
                                LoggedSet(weight: previous?.weight ?? 0, reps: previous?.reps ?? 8)
                            )
                        } label: {
                            Label("Add Set", systemImage: "plus")
                        }
                    } header: {
                        Text(workoutExercise.exercise.name)
                    }
                }
            }
            .navigationTitle("Active Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Rest Time", selection: $restDuration) {
                            Text("30 sec").tag(30)
                            Text("60 sec").tag(60)
                            Text("90 sec").tag(90)
                            Text("2 min").tag(120)
                            Text("3 min").tag(180)
                        }
                    } label: {
                        Label("Rest: \(restDuration)s", systemImage: "timer")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Finish") { showingFinishAlert = true }
                        .fontWeight(.semibold)
                }
            }
            .onReceive(timer) { _ in
                guard timerRunning else { return }
                if remainingRest > 1 {
                    remainingRest -= 1
                } else {
                    remainingRest = 0
                    timerRunning = false
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                }
            }
            .alert("Finish workout?", isPresented: $showingFinishAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Save Workout") { finishWorkout() }
            } message: {
                Text("Your completed sets will be saved to workout history.")
            }
        }
    }

    private func setNumber(for id: UUID, in exercise: WorkoutExercise) -> Int {
        (exercise.sets.firstIndex { $0.id == id } ?? 0) + 1
    }

    private func startRestTimer() {
        remainingRest = restDuration
        timerRunning = true
    }

    private func stopTimer() {
        remainingRest = 0
        timerRunning = false
    }

    private func finishWorkout() {
        let duration = max(0, Int(Date().timeIntervalSince(startDate)))
        store.saveWorkout(
            Workout(
                exercises: workoutExercises,
                durationSeconds: duration,
                programWeek: programWeek,
                programDay: programDay
            )
        )
        onFinish()
        dismiss()
    }
}

private struct SetRow: View {
    let setNumber: Int
    @Binding var set: LoggedSet
    let onCompletionChanged: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text("\(setNumber)")
                .font(.headline.monospacedDigit())
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text("Weight (lb)").font(.caption).foregroundStyle(.secondary)
                TextField("0", value: $set.weight, format: .number.precision(.fractionLength(0...1)))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Reps").font(.caption).foregroundStyle(.secondary)
                TextField("0", value: $set.reps, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }
            .frame(width: 75)

            Button {
                set.completed.toggle()
                onCompletionChanged()
            } label: {
                Image(systemName: set.completed ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(set.completed ? .green : .secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(set.completed ? "Mark set incomplete" : "Complete set")
        }
        .padding(.vertical, 4)
    }
}

private struct RestTimerCard: View {
    let remaining: Int
    let duration: Int
    let isRunning: Bool
    let onPauseResume: () -> Void
    let onSkip: () -> Void

    private var progress: Double {
        guard duration > 0 else { return 0 }
        return Double(remaining) / Double(duration)
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("REST")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            Text(timeText)
                .font(.system(size: 46, weight: .bold, design: .rounded))
                .monospacedDigit()
            ProgressView(value: progress)
            HStack {
                Button(isRunning ? "Pause" : "Resume", action: onPauseResume)
                    .buttonStyle(.bordered)
                Button("Skip", action: onSkip)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var timeText: String {
        String(format: "%d:%02d", remaining / 60, remaining % 60)
    }
}
