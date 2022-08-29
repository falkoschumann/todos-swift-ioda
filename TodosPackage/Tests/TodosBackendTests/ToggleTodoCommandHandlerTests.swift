@testable import TodosBackend
import XCTest

import TodosContract

final class ToggleTodoCommandHandlerTests: XCTestCase {
    func testActivatesATodo() throws {
        try runToggleTodo(
            givenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ],
            whenCommand: ToggleTodoCommand(id: 1),
            thenStatus: .success,
            thenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: false),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ]
        )
    }

    func testCompletesATodo() throws {
        try runToggleTodo(
            givenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ],
            whenCommand: ToggleTodoCommand(id: 2),
            thenStatus: .success,
            thenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: true),
            ]
        )
    }

    func runToggleTodo(
        givenTodos: [Todo],
        whenCommand: ToggleTodoCommand,
        thenStatus: CommandStatus,
        thenTodos: [Todo]
    ) throws {
        let todosRepository = MemoryTodosRepository(givenTodos)
        let toggleTodo = createToggleTodoCommandHandler(todosRepository: todosRepository)

        let status = toggleTodo(whenCommand)

        XCTAssertEqual(status, thenStatus)
        XCTAssertEqual(todosRepository.load(), thenTodos)
    }

    func testFails() throws {
        let todosRepository = FailureTodosRepository()
        let toggleTodo = createToggleTodoCommandHandler(todosRepository: todosRepository)

        let whenCommand = ToggleTodoCommand(id: 1)
        let status = toggleTodo(whenCommand)

        let thenStatus = CommandStatus.failure(
            errorMessage: "Todo \"1\" could not be toggled: something is strange"
        )
        XCTAssertEqual(status, thenStatus)
    }
}
