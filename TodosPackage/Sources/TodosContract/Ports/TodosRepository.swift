import Foundation

public protocol TodosRepository {
    func load() throws -> [Todo]
    func store(todos: [Todo]) throws
}

public struct TodosRepositoryError: LocalizedError {
    public var errorDescription: String?

    public init(description: String) {
        errorDescription = description
    }
}
