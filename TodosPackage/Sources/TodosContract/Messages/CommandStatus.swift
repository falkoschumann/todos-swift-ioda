import Foundation

public enum CommandStatus: Equatable {
    case success
    case failure(errorMessage: String)
}
