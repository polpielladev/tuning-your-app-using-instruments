import Foundation
import SwiftData

enum StorageSchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [
            Profile.self
        ]
    }
    static let versionIdentifier: Schema.Version = .init(1, 0, 0)
    
    @Model
    final class Profile {
        var id: String = ""
        var name: String = ""
        @Attribute(.externalStorage)
        var photo: Data?
        
        init(id: String, name: String, photo: Data?) {
            self.id = id
            self.name = name
            self.photo = photo
        }
    }
}
