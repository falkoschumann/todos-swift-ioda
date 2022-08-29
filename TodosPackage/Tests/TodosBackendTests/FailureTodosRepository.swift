import Foundation

import TodosContract

class FailureTodosRepository: TodosRepository {
    func load() throws -> [Todo] {
        throw TodosRepositoryError(description: "something is strange")
    }

    // swiftformat:disable:next unusedArguments
    func store(todos: [Todo]) throws {
        throw TodosRepositoryError(description: "something is strange")
    }
}
