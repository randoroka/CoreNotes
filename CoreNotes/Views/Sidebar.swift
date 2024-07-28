//
//  Sidebar.swift
//  CoreNotes
//

import SwiftUI
import Firebase
import CoreData


public struct Sidebar: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Folder.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: true)]
    ) private var folders: FetchedResults<Folder>

    // Use KeychainManager to retrieve userID
    let keychainManager = KeyChainManager()

    @State private var isPresented: Bool = false
    @State var selectedFolder: Folder? = nil
    @AppStorage("log_Status") var status = false

    public var body: some View {
        VStack {
            Button { // Add folder button
                isPresented = true
            } label: {
                HStack {
                    Image(systemName: "folder.badge.plus")
                    Text("Add Folder")
                }
                .cornerRadius(50)
            }
            .sheet(isPresented: $isPresented) {
                AddFolderView { name in
                    if let userID = try? keychainManager.getUserIDFromKeychain(), !userID.isEmpty {
                        addFolder(name: name, userID: userID)
                    } else {
                        // Handle the case where user ID is empty or cannot be retrieved
                        print("User ID is empty or cannot be retrieved, cannot add folder")
                    }
                }
            }
            .padding(.top, 20)

            Text("Folders")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 10)
            Divider()

            // Lists all created folders for the retrieved userID
            if folders.isEmpty {
                Text("")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
            } else {
                List(folders.filter { folder in
                    if let userID = try? keychainManager.getUserIDFromKeychain() {
                        return folder.userID == userID
                    }
                    return false
                }, id: \.self, selection: $selectedFolder) { folder in
                    VStack(alignment: .leading) {
                        NavigationLink(destination: NoteView(folder: folder, selectedFolder: $selectedFolder)) {
                            HStack {
                                Text(folder.name ?? "Unnamed Folder")
                                Spacer()
                                Text("\(folder.notesArray.count)") // displays amount of notes in folder
                            }
                        }
                        Text(formatDate(folder.date)) // shows date folder was created
                            .font(.system(size: 10))
                    }
                    .onTapGesture {
                        self.selectedFolder = folder
                        print("Selected folder: \(folder.name ?? "Unnamed Folder")")
                    }
                }
            }
        }
        // Toolbar needs to be outside the conditional block
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: toggleSidebar) {
                    Label("Toggle Sidebar", systemImage: "sidebar.left") // makes sidebar disappear
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    deleteSelectedFolder()
                }, label: { Label("Delete folder", systemImage: "trash") })
            }

            ToolbarItem(placement: .primaryAction) { // logs out user
                Button(action: logout) {
                    Text("Logout")
                }
            }
        }
    }

    private func addFolder(name: String, userID: String) {
        let newFolder = Folder(context: viewContext)
        newFolder.name = name
        newFolder.userID = userID
        newFolder.date = Date()

        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error saving folder: \(error.localizedDescription)")
        }
    }

    private func deleteSelectedFolder() {
        if let selectedFolder = selectedFolder {
            viewContext.delete(selectedFolder)
            self.selectedFolder = nil  // Ensure the selected folder is reset
            do {
                try viewContext.save()
                print("Folder deleted successfully")
            } catch {
                print("Error deleting folder: \(error.localizedDescription)")
            }
        } else {
            print("Folder is nil")
        }
    }

    private func logout() {
        try? Auth.auth().signOut()
        withAnimation { status = false }
    }

    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }

    private func formatDate(_ date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, MMM d y"
        if let date = date {
            return formatter.string(from: date)
        }
        return "Unknown"
    }
}
