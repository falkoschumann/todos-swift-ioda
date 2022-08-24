@testable import TodosBackend
import XCTest

import TodosContract

final class ToggleAllCommandHandlerTests: XCTestCase {
    func testSetAllTodosCompleted() throws {
        try runToggleAll(
            givenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ],
            whenCommand: ToggleAllCommand(checked: true),
            thenStatus: .success,
            thenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: true),
            ]
        )
    }

    func testSetAllTodosActive() throws {
        try runToggleAll(
            givenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ],
            whenCommand: ToggleAllCommand(checked: false),
            thenStatus: .success,
            thenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: false),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ]
        )
    }

    func runToggleAll(
        givenTodos: [Todo],
        whenCommand: ToggleAllCommand,
        thenStatus: CommandStatus,
        thenTodos: [Todo]
    ) throws {
        let todosRepository = MemoryTodoRepository(givenTodos)
        let toggleAll = createToggleAllCommandHandler(todosRepository: todosRepository)

        let status = toggleAll(whenCommand)

        XCTAssertEqual(status, thenStatus)
        XCTAssertEqual(todosRepository.load(), thenTodos)
    }
}
