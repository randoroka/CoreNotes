//
//  AddNoteView.swift
//  CoreNotes
//
//  Created by Ariel on 12/29/22.
//

import SwiftUI

struct AddNoteView: View {
    // popup when button is pressed to create new note
    @Environment(\.presentationMode) var presentationMode
    @State private var newNoteName: String = ""
    var Save: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing:20){
            HStack{
                
                //lets you cancel out of making new note
                Button("Cancel"){
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black) 
                
                //lets you continue to ne wnote
                Button("Done"){
                    Save(newNoteName)
                    presentationMode.wrappedValue.dismiss()
                }
                //Disables Done button if textfield is empty
                .disabled(newNoteName.isEmpty)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.black)
            }
            VStack{
                TextField("Note Name", text: $newNoteName)
                    .foregroundColor(.white)
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
