@testable import TodosBackend
import XCTest

import TodosContract

final class DestroyTodoCommandTests: XCTestCase {
    func testDestroyATodo() throws {
        let givenTodos = [
            Todo(id: 1, title: "Taste JavaScript", completed: true),
            Todo(id: 2, title: "Buy Unicorn", completed: false),
        ]
        let todosRepository = MemoryTodoRepository(givenTodos)
        let destroyTodo = createDestroyTodoCommandHandler(todosRepository: todosRepository)

        let whenCommand = DestroyTodoCommand(id: 2)
        let status = destroyTodo(whenCommand)

        XCTAssertEqual(status, CommandStatus.success)
        let thenTodos = [
            Todo(id: 1, title: "Taste JavaScript", completed: true),
        ]
        XCTAssertEqual(todosRepository.load(), thenTodos)
    }
}
