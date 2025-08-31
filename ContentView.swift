//
//  ContentView.swift
//  Fichar Horas
//
//  Created by Javier Rodríguez on 31/8/25.
//

iimport SwiftUI
    .navigationTitle("Consultar horas")
    .onAppear { vm.startListening() }
    }
    }

    struct SessionRow: View {
    let session: WorkSession

    var body: some View {
    VStack(alignment: .leading, spacing: 6) {
    HStack {
    Text(dateInterval)
    .font(.headline)
    Spacer()
    Text(duration)
    .font(.system(.subheadline, design: .monospaced))
    .padding(.horizontal, 10)
    .padding(.vertical, 6)
    .background(Color.secondary.opacity(0.12))
    .clipShape(Capsule())
    }
    Text("Estado: \(session.status.rawValue.capitalized)")
    .foregroundStyle(.secondary)
    .font(.subheadline)
    }
    .padding(10)
    }

    private var dateInterval: String {
    let start = session.start.formatted(date: .abbreviated, time: .shortened)
    let end = (session.end ?? session.updatedAt).formatted(date: .abbreviated, time: .shortened)
    return "\(start) → \(end)"
    }

    private var duration: String {
    guard let end = session.end else { return "En curso" }
    let total = Int(end.timeIntervalSince(session.start)) - session.totalPausedSeconds
    return TimeTrackerViewModel.format(seconds: max(total, 0))
    }
    }

    struct CloudStatusView: View {
    @State private var uid: String? = Auth.auth().currentUser?.uid
    var body: some View {
    HStack(spacing: 8) {
    Image(systemName: "icloud.fill")
    if let uid { Text(String(uid.prefix(6))) }
    }
    .onReceive(NotificationCenter.default.publisher(for: .AuthStateDidChange)) { _ in
    uid = Auth.auth().currentUser?.uid
    }
    .font(.footnote)
    .foregroundStyle(.secondary)
    }
    }

    // MARK: - Helpers
    extension Notification.Name { static let AuthStateDidChange = Notification.Name("AuthStateDidChange") }
    extension Auth {
    // Emit notification when auth user changes
    static func observeAuthChanges() {
    _ = Auth.auth().addStateDidChangeListener { _, _ in
    NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
    }
    }
    }

    // Start listening for auth changes on launch
    @MainActor
    func _bootstrapAuthObservation() {
    Auth.observeAuthChanges()
    }

    // Call it as soon as SwiftUI scene starts
    struct _Bootstrapper: View { var body: some View { Color.clear.onAppear { _bootstrapAuthObservation() } } }
