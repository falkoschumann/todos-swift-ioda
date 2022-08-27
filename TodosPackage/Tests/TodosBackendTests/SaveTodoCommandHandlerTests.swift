@testable import TodosBackend
import XCTest

import TodosContract

final class SaveTodoCommandHandlerTests: XCTestCase {
    func testChangesTodosTitle() throws {
        try runSaveTodo(
            givenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ],
            whenCommand: SaveTodoCommand(id: 1, title: "Taste TypeScript"),
            thenStatus: .success,
            thenTodos: [
                Todo(id: 1, title: "Taste TypeScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ]
        )
    }

    func testTrimsTitle() throws {
        try runSaveTodo(
            givenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ],
            whenCommand: SaveTodoCommand(id: 1, title: "  Taste TypeScript   "),
            thenStatus: .success,
            thenTodos: [
                Todo(id: 1, title: "Taste TypeScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ]
        )
    }

    func testDestroysTodoIfTitleIsEmpty() throws {
        try runSaveTodo(
            givenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ],
            whenCommand: SaveTodoCommand(id: 1, title: "  "),
            thenStatus: .success,
            thenTodos: [
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ]
        )
    }

    func runSaveTodo(
        givenTodos: [Todo],
        whenCommand: SaveTodoCommand,
        thenStatus: CommandStatus,
        thenTodos: [Todo]
    ) throws {
        let todosRepository = MemoryTodoRepository(givenTodos)
        let saveTodo = createSaveTodoCommandHandler(todosRepository: todosRepository)

        let status = saveTodo(whenCommand)

        XCTAssertEqual(status, thenStatus)
        XCTAssertEqual(todosRepository.load(), thenTodos)
    }
}
