@testable import TodosBackend
import XCTest

import TodosContract

final class SelectTodosQueryHandlerTests: XCTestCase {
    func testReturnsAllTodos() throws {
        let givenTodos = [
            Todo(id: 1, title: "Taste JavaScript", completed: true),
            Todo(id: 2, title: "Buy Unicorn", completed: false),
        ]
        let todosRepository = MemoryTodoRepository(givenTodos)
        let selectTodos = createSelectTodosQueryHandler(todosRepository: todosRepository)

        let whenQuery = SelectTodosQuery()
        let result = selectTodos(whenQuery)

        let thenResult = SelectTodosQueryResult(todos: [
            Todo(id: 1, title: "Taste JavaScript", completed: true),
            Todo(id: 2, title: "Buy Unicorn", completed: false),
        ])
        XCTAssertEqual(result, thenResult)
    }
}
