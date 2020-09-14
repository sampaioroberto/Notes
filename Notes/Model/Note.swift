import Foundation

struct Note: Hashable {
    var identifier = UUID()
    var title: String
    var description: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }

    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
