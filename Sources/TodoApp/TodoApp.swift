import SwiftUI
import SwiftData

@main
struct TodoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(ColorPalette.skyBlue) // Set global accent color
        }
        .modelContainer(for: TodoItem.self)
    }
}
