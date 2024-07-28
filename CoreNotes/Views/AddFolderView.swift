//
//  AddFolderView.swift
//  CoreNotes
//


import SwiftUI

struct AddFolderView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var newFolderName: String = ""
    var save: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)
                
                Button("Done") {
                    save(newFolderName)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(newFolderName.isEmpty)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.black)
            }
            VStack {
                TextField("Folder Name", text: $newFolderName)
                    .foregroundColor(.black)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.949, green: 0.946, blue: 0.966).opacity(0.1))
    }
}

