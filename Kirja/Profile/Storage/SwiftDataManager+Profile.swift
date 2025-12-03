import UIKit

extension StorageProfile: StorageEntity {
    convenience init(from domainModel: ProfileModel) {
        self.init(
            id: domainModel.id,
            name: domainModel.name,
            photo: domainModel.photo
        )
    }
    
    func toDomainModel() -> ProfileModel {
        return ProfileModel(
            id: self.id,
            photo: self.photo,
            name: self.name
        )
    }
    
    func update(from domainModel: ProfileModel) {
        self.name = domainModel.name
        self.id = domainModel.id
        self.photo = domainModel.photo
    }
}
