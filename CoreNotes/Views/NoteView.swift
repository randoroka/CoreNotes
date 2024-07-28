//
//  NoteView.swift
//  CoreNotes
//


import SwiftUI

// notes view 
struct NoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isPresented: Bool = false
    @ObservedObject var folder: Folder
    
    @Binding var selectedFolder: Folder?
    @State var selectedNote: Note? = nil
    
    var body: some View {
        //lists all created notes
        
        List(selection: $selectedNote){
            ForEach(folder.notesArray, id: \.self){ note in
                NavigationLink(note.name!, destination: NoteEditor(note: note))
                Divider()
                
            }
        }
        .toolbar{
            //button to create new note
            ToolbarItem(placement: .primaryAction){
                Button(){
                    isPresented.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                .sheet(isPresented: $isPresented){ // brings up AddNoteView
                    AddNoteView{ name in
                        viewContext.addNote(name, text: "", color: "", folder: folder)
                    }
                }
            }
            
            ToolbarItem(placement: .primaryAction){
                Button(action: {viewContext.deleteNote(selectedNote!)
                    selectedNote = nil
                }, label:{ Label("Delete note", systemImage: "trash")} )
                
                
            }
        }
    }
    
}
