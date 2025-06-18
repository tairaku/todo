import XCTest
import SwiftData
@testable import TodoApp // Replace TodoApp with your actual app module name if different

final class TodoItemTests: XCTestCase {

    var modelContext: ModelContext!

    @MainActor
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Create an in-memory model container for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TodoItem.self, configurations: config)
        modelContext = ModelContext(container)
    }

    override func tearDownWithError() throws {
        modelContext = nil
        try super.tearDownWithError()
    }

    @MainActor
    func testCreateTodoItem() throws {
        let initialTitle = "Test Todo"
        let initialDescription = "Test Description"
        let newItem = TodoItem(title: initialTitle, itemDescription: initialDescription, isCompleted: false)

        modelContext.insert(newItem)

        // Fetch the item to verify insertion
        // We need to use the item's ID or a specific predicate if there could be other items
        let fetchDescriptor = FetchDescriptor<TodoItem>(
            predicate: #Predicate { $0.id == newItem.id }
        )
        let fetchedItems = try modelContext.fetch(fetchDescriptor)

        XCTAssertEqual(fetchedItems.count, 1, "Should be one item in the context after insertion.")
        let savedItem = try XCTUnwrap(fetchedItems.first)

        XCTAssertEqual(savedItem.title, initialTitle, "Title should match initial title.")
        XCTAssertEqual(savedItem.itemDescription, initialDescription, "Description should match initial description.")
        XCTAssertFalse(savedItem.isCompleted, "Item should not be completed initially.")
        XCTAssertNotNil(savedItem.createdAt, "createdAt should be set.")
        XCTAssertNotNil(savedItem.id, "id should be set.")
    }

    @MainActor
    func testToggleTodoItemCompletion() throws {
        let item = TodoItem(title: "Toggle Test", itemDescription: "Check completion toggle")
        modelContext.insert(item)

        // Verify initial state
        XCTAssertFalse(item.isCompleted, "Item should initially be incomplete.")

        // Toggle completion
        item.isCompleted.toggle()

        // Fetch to confirm change (SwiftData might update in place, but fetching confirms persistence layer)
        let fetchDescriptor = FetchDescriptor<TodoItem>(
            predicate: #Predicate { $0.id == item.id }
        )
        let fetchedItems = try modelContext.fetch(fetchDescriptor)
        let updatedItem = try XCTUnwrap(fetchedItems.first)

        XCTAssertTrue(updatedItem.isCompleted, "Item should be marked as completed after toggle.")

        // Toggle back
        updatedItem.isCompleted.toggle()
        let reFetchedItems = try modelContext.fetch(fetchDescriptor)
        let revertedItem = try XCTUnwrap(reFetchedItems.first)

        XCTAssertFalse(revertedItem.isCompleted, "Item should be marked as incomplete after second toggle.")
    }

    @MainActor
    func testDeleteTodoItem() throws {
        let item1 = TodoItem(title: "To Delete")
        let item2 = TodoItem(title: "To Keep")

        modelContext.insert(item1)
        modelContext.insert(item2)

        // Verify initial count
        var fetchDescriptor = FetchDescriptor<TodoItem>()
        var allItems = try modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(allItems.count, 2, "Should be two items before deletion.")

        // Delete item1
        modelContext.delete(item1)

        // Verify count after deletion
        allItems = try modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(allItems.count, 1, "Should be one item after deletion.")

        // Verify the correct item was deleted
        let remainingItem = try XCTUnwrap(allItems.first)
        XCTAssertEqual(remainingItem.title, "To Keep", "The remaining item should be 'To Keep'.")

        // Verify that the deleted item is no longer fetchable by its ID
        let deletedItemFetchDescriptor = FetchDescriptor<TodoItem>(predicate: #Predicate { $0.id == item1.id })
        let deletedItems = try modelContext.fetch(deletedItemFetchDescriptor)
        XCTAssertTrue(deletedItems.isEmpty, "Deleted item should not be fetchable.")
    }
}

// Note: Ensure your project's main target (e.g., "TodoApp") is added to the
// "Target Membership" for TodoItem.swift so the test target can access it.
// Also, ensure the test target is correctly configured in your Xcode project scheme to run.
