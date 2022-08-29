@testable import TodosBackend
import XCTest

import TodosContract

final class DestroyTodoCommandTests: XCTestCase {
    func testDestroysATodo() throws {
        let givenTodos = [
            Todo(id: 1, title: "Taste JavaScript", completed: true),
            Todo(id: 2, title: "Buy Unicorn", completed: false),
        ]
        let todosRepository = MemoryTodosRepository(givenTodos)
        let destroyTodo = createDestroyTodoCommandHandler(todosRepository: todosRepository)

        let whenCommand = DestroyTodoCommand(id: 2)
        let status = destroyTodo(whenCommand)

        XCTAssertEqual(status, CommandStatus.success)
        let thenTodos = [
            Todo(id: 1, title: "Taste JavaScript", completed: true),
        ]
        XCTAssertEqual(todosRepository.load(), thenTodos)
    }

    func testFails() throws {
        let todosRepository = FailureTodosRepository()
        let destroyTodo = createDestroyTodoCommandHandler(todosRepository: todosRepository)

        let whenCommand = DestroyTodoCommand(id: 1)
        let status = destroyTodo(whenCommand)

        let thenStatus = CommandStatus.failure(
            errorMessage: "Todo \"1\" could not be destroyed: something is strange"
        )
        XCTAssertEqual(status, thenStatus)
    }
}
