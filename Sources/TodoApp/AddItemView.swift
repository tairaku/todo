import SwiftUI

struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var itemDescription: String = ""

    var body: some View {
        NavigationView { // Or NavigationStack if preferred and consistent
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $itemDescription, axis: .vertical)
            }
            .navigationTitle("New Todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveItem()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    private func saveItem() {
        let newItem = TodoItem(title: title, itemDescription: itemDescription)
        modelContext.insert(newItem)
    }
}

#Preview {
    AddItemView()
        .accentColor(ColorPalette.skyBlue) // Apply accent color to preview
        // .modelContainer(for: TodoItem.self, inMemory: true) // Already commented out, good
}
