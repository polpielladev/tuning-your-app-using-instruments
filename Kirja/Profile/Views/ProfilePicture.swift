import SwiftUI
import PhotosUI

struct ProfilePicture: View {
    @Binding var profile: ProfileModel
    let isEditable: Bool
    @State private var imageSelection: PhotosPickerItem? = nil

    var photo: UIImage? {
        guard let data = profile.photo else { return nil }

        return UIImage(data: data)
    }

    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.quinary)
            
            PhotosPicker(selection: $imageSelection,
                         matching: .images,
                         photoLibrary: .shared()) {
                if let photo {
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                        .transition(.blurReplace)
                } else {
                    Image(systemName: isEditable ? "plus" : "person.fill")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                }
            }
            .disabled(!isEditable)
            .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
        }
        .animation(.default, value: isEditable)
        .animation(.default, value: profile.photo)
        .onChange(of: imageSelection) {
            guard let imageSelection else { return }
            
            imageSelection.loadTransferable(type: Data.self) { result in
                guard let data = try? result.get() else { return }
                profile.photo = data
            }
        }
        .frame(width: 72, height: 72)
    }
}
