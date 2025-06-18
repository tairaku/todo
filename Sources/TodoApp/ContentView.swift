import SwiftUI
import SwiftData // SwiftData imports Foundation indirectly, but being explicit with Foundation.SortDescriptor
import Foundation // Explicitly import Foundation for SortDescriptor

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    // Query now sorts by isCompleted first, then by createdAt, with fully explicit Foundation.SortDescriptor and order
    @Query(sort: [
        Foundation.SortDescriptor<TodoItem>(\TodoItem.isCompleted, order: .forward),
        Foundation.SortDescriptor<TodoItem>(\TodoItem.createdAt, order: .forward)
    ]) private var items: [TodoItem]
    @State private var showingAddItemView = false

    public init() {} // Public initializer

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                                .strikethrough(item.isCompleted, color: .black) // Strikethrough if completed
                            Text(item.itemDescription)
                                .font(.subheadline)
                                .strikethrough(item.isCompleted, color: .gray) // Strikethrough if completed
                        }
                        Spacer() // Pushes the checkmark to the trailing edge
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isCompleted ? .green : .gray)
                            .onTapGesture {
                                toggleCompletion(for: item)
                            }
                    }
                    // It's often better to have a larger tap area for toggling completion,
                    // so consider applying onTapGesture to the HStack or a wrapping view if needed.
                    // For simplicity, applying to Image here.
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddItemView = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                // Optional: Add EditButton back if you want to use swipe-to-delete alongside other edit actions
                // ToolbarItem(placement: .navigationBarLeading) {
                //     EditButton()
                // }
            }
            .sheet(isPresented: $showingAddItemView) {
                AddItemView()
            }
        }
    }

    private func toggleCompletion(for item: TodoItem) {
        item.isCompleted.toggle()
        // SwiftData should automatically save changes to the model context
        // but if issues arise, explicit save can be added:
        // try? modelContext.save()
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(modelContext.delete)
            // try? modelContext.save() // if needed
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
