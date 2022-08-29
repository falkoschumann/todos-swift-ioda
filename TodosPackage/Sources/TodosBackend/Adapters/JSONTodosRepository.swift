import Foundation

import TodosContract

public class JSONTodosRepository: TodosRepository {
    private let file: String

    public init(file: String) {
        self.file = file
    }

    public func load() throws -> [Todo] {
        guard FileManager().fileExists(atPath: file) else {
            return []
        }

        do {
            let url = URL(fileURLWithPath: file)
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([Todo].self, from: jsonData)
        } catch {
            throw TodosRepositoryError(
                description: "could not load todos from file \(file): \(error.localizedDescription)"
            )
        }
    }

    public func store(todos: [Todo]) throws {
        do {
            let url = URL(fileURLWithPath: file)
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(todos)
            try jsonData.write(to: url)
        } catch {
            throw TodosRepositoryError(
                description: "could not store todos to file \(file): \(error.localizedDescription)"
            )
        }
    }
}
