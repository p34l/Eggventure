//
//  ProfileView.swift
//  Eggventure
//
//  Created by Misha Kandaurov on 14.09.2025.
//

import PhotosUI
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationPath: NavigationPath
    @State private var showingEditUsername = false
    @State private var showingEditEmail = false
    @State private var tempUsername = ""
    @State private var tempEmail = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var showingPhotoOptions = false
    @State private var showingImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        ZStack {
            Image("loading_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                NavigationHeader(
                    leftButton: NavigationButton(imageName: "back", action: { dismiss() })
                )

                Spacer()

                VStack(spacing: 0) {
                    Text("PROFILE")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                    VStack(spacing: 20) {
                        VStack(spacing: 10) {
                            if let imageData = userSettings.userProfileImage,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                    )
                            } else {
                                Image("hero")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                    )
                            }

                            Button(action: {
                                showingPhotoOptions = true
                            }) {
                                Text("Change Photo")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.pink.opacity(0.7))
                                    )
                            }
                        }

                        VStack(spacing: 15) {
                            ProfileFieldView(
                                title: "Username",
                                value: userSettings.playerName.isEmpty ? "Username" : userSettings.playerName,
                                onEdit: {
                                    tempUsername = userSettings.playerName
                                    showingEditUsername = true
                                }
                            )

                            ProfileFieldView(
                                title: "Email",
                                value: userSettings.userEmail.isEmpty ? "Email" : userSettings.userEmail,
                                onEdit: {
                                    tempEmail = userSettings.userEmail
                                    showingEditEmail = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.purple.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.3), lineWidth: 2)
                        )
                )
                .padding(.horizontal, 40)

                Spacer()

                Button(action: {
                    if !navigationPath.isEmpty {
                        navigationPath.removeLast()
                    }
                }) {
                    ZStack {
                        Image("with_save")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 60)

                        Image("save")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .onChange(of: selectedPhoto) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    userSettings.userProfileImage = data
                }
            }
        }
        .confirmationDialog("Select Photo", isPresented: $showingPhotoOptions) {
            Button("Take Photo") {
                imagePickerSourceType = .camera
                showingImagePicker = true
            }
            Button("Choose from Library") {
                imagePickerSourceType = .photoLibrary
                showingImagePicker = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(sourceType: imagePickerSourceType, selectedImage: $userSettings.userProfileImage)
        }
        .sheet(isPresented: $showingEditUsername) {
            EditUsernameSheet(
                username: $tempUsername,
                isPresented: $showingEditUsername,
                onSave: {
                    userSettings.playerName = tempUsername
                }
            )
        }
        .sheet(isPresented: $showingEditEmail) {
            EditEmailSheet(
                email: $tempEmail,
                isPresented: $showingEditEmail,
                onSave: {
                    userSettings.userEmail = tempEmail
                }
            )
        }
    }

    struct ProfileFieldView: View {
        let title: String
        let value: String
        let onEdit: () -> Void

        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))

                    Text(value)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }

                Spacer()

                Button(action: onEdit) {
                    Text("Edit")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.pink.opacity(0.7))
                        )
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.pink.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }

    struct EditUsernameSheet: View {
        @Binding var username: String
        @Binding var isPresented: Bool
        let onSave: () -> Void

        var body: some View {
            VStack(spacing: 20) {
                Text("Edit Username")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                HStack(spacing: 20) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.7))
                    )

                    Button("Save") {
                        onSave()
                        isPresented = false
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.pink.opacity(0.7))
                    )
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.purple.opacity(0.9))
            .presentationDetents([.height(250)])
        }
    }

    struct EditEmailSheet: View {
        @Binding var email: String
        @Binding var isPresented: Bool
        let onSave: () -> Void

        var body: some View {
            VStack(spacing: 20) {
                Text("Edit Email")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)

                HStack(spacing: 20) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.7))
                    )

                    Button("Save") {
                        onSave()
                        isPresented = false
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.pink.opacity(0.7))
                    )
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.purple.opacity(0.9))
            .presentationDetents([.height(250)])
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: Data?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image.jpegData(compressionQuality: 0.8)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

