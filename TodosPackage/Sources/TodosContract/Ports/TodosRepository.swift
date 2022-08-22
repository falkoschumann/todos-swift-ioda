import Foundation

public protocol TodosRepository {
    func load() -> [Todo]
    func store(todos: [Todo])
}
