import Foundation

extension String {
    func pluralize(count: Int) -> String {
        if count == 1 {
            return self
        } else {
            return self + "s"
        }
    }
}
