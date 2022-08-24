@testable import TodosBackend
import XCTest

import TodosContract

final class ClearCompletedCommandHandlerTests: XCTestCase {
    func testremovesCompletedTodos() throws {
        let givenTodos = [
            Todo(id: 1, title: "Taste JavaScript", completed: true),
            Todo(id: 2, title: "Buy Unicorn", completed: false),
        ]
        let todosRepository = MemoryTodoRepository(givenTodos)
        let clearCompleted = createClearCompletedCommandHandler(todosRepository: todosRepository)

        let whenCommand = ClearCompletedCommand()
        let status = clearCompleted(whenCommand)

        XCTAssertEqual(status, CommandStatus.success)
        let thenTodos = [
            Todo(id: 2, title: "Buy Unicorn", completed: false),
        ]
        XCTAssertEqual(todosRepository.load(), thenTodos)
    }
}
