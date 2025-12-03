import SwiftUI
import Foundation
import SwiftData

struct Profile: View {
    @State private var viewModel = ProfileViewModel()
    @FocusState private var isFocused

    var body: some View {
        NavigationStack {
            VStack {
                ProfilePicture(profile: viewModel.isEditingProfile ? $viewModel.tempProfile : $viewModel.profile, isEditable: viewModel.isEditingProfile)

                if viewModel.isEditingProfile {
                    TextField("Name", text: $viewModel.tempProfile.name)
                        .font(.largeTitle)
                        .focused($isFocused)
                        .textContentType(.givenName)
                        .onSubmit {
                            Task {
                                await viewModel.confirm()
                            }
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
                                await viewModel.confirm()
                            }
                        } label: {
                            if viewModel.isSaving {
                                ProgressView()
                            } else {
                                Image(systemName: "checkmark")
                            }
                        }
                        .tint(.accentColor)
                    }
                } else {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            viewModel.isEditingProfile.toggle()
                            viewModel.tempProfile = viewModel.profile
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
