@testable import TodosBackend
import XCTest

import TodosContract

final class AddTodoCommandHandlerTests: XCTestCase {
    func testSavesNewTodo() throws {
        try runAddTodo(
            givenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
            ],
            whenCommand: AddTodoCommand(title: "Buy Unicorn"),
            thenStatus: .success,
            thenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ]
        )
    }

    func testSavesTrimmedTitle() throws {
        try runAddTodo(
            givenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
            ],
            whenCommand: AddTodoCommand(title: "  Buy Unicorn   "),
            thenStatus: .success,
            thenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
                Todo(id: 2, title: "Buy Unicorn", completed: false),
            ]
        )
    }

    func testDoesNothingIfTitleIsEmpty() throws {
        try runAddTodo(
            givenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
            ],
            whenCommand: AddTodoCommand(title: "  "),
            thenStatus: .success,
            thenTodos: [
                Todo(id: 1, title: "Taste JavaScript", completed: true),
            ]
        )
    }

    func runAddTodo(
        givenTodos: [Todo],
        whenCommand: AddTodoCommand,
        thenStatus: CommandStatus,
        thenTodos: [Todo]
    ) throws {
        let todosRepository = MemoryTodosRepository(givenTodos)
        let addTodo = createAddTodoCommandHandler(todosRepository: todosRepository)

        let status = addTodo(whenCommand)

        XCTAssertEqual(status, thenStatus)
        XCTAssertEqual(todosRepository.load(), thenTodos)
    }

    func testFails() throws {
        let todosRepository = FailureTodosRepository()
        let addTodo = createAddTodoCommandHandler(todosRepository: todosRepository)

        let whenCommand = AddTodoCommand(title: "Taste JavaScript")
        let status = addTodo(whenCommand)

        let thenStatus = CommandStatus.failure(
            errorMessage: "Todo \"Taste JavaScript\" could not be added: something is strange"
        )
        XCTAssertEqual(status, thenStatus)
    }
}
