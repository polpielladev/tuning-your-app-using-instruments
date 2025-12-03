import SwiftUI
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


@Observable @MainActor final class ProfileViewModel {
    var isEditingProfile = false
    var tempProfile = ProfileModel.empty
    var profile = ProfileModel.empty
}

struct Profile: View {
    @State private var viewModel = ProfileViewModel()
    @FocusState private var isFocused

    var body: some View {
        NavigationStack {
            VStack {
    //            ProfilePicture(profile: manager.editProfile ? $tempProfile : $manager.profile, isEditable: manager.editProfile)

                if viewModel.isEditingProfile {
                    TextField("Name", text: $viewModel.tempProfile.name)
                        .font(.largeTitle)
                        .focused($isFocused)
                        .textContentType(.givenName)
                        .onSubmit {
                        }
                        .opacity(viewModel.isEditingProfile ? 1 : 0)
                } else {
                    Text(viewModel.profile.name)
                        .font(.largeTitle)
                        .opacity(viewModel.isEditingProfile ? 0 : 1)
                }

                Spacer()
            }
            .frame(maxWidth: 440)
            .multilineTextAlignment(.center)
            .toolbar {
                if viewModel.isEditingProfile {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { viewModel.isEditingProfile.toggle() }) {
                            Image(systemName: "xmark")
                        }
                    }
                }

                if viewModel.isEditingProfile {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(role: .confirm) {
                            Task {
                                viewModel.isEditingProfile.toggle()
                                isFocused = false
                            }
                        }
                        .tint(.accentColor)
                    }
                } else {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            viewModel.isEditingProfile.toggle()
                            isFocused = viewModel.isEditingProfile
                        }) {
                            Image(systemName: viewModel.isEditingProfile ? "checkmark" : "pencil")
                        }
                    }
                }
            }
            .padding()
        }
    }
}
