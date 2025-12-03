import Foundation

public struct ProfileModel: Sendable, Identifiable {
    public var id: String
    public var photo: Data?
    public var name: String

    public init(id: String, photo: Data?, name: String) {
        self.id = id
        self.photo = photo
        self.name = name
    }

    public static let empty: ProfileModel = ProfileModel(id: UUID().uuidString, photo: nil, name: "You")
}
