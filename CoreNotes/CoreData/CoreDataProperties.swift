//
//  CoreDataProperties.swift
//  CoreNotes
//

import SwiftUI
import CoreData



extension Folder {
    public var notesArray: [Note] {
        let set = notes as? Set<Note> ?? []
        
        return set.sorted { note1, note2 in
            return note1.dateModified! > note2.dateModified!
        }
    }
}

extension NSManagedObjectContext {
    func addNote(_ name: String, text: String, color: String, folder: Folder) {
        withAnimation {
            let new = Note(context: self)
            new.name = name
            new.text = text
            new.color = color
            new.dateCreated = Date()
            new.dateModified = Date()
            new.folder = folder
            try? PersistenceController.shared.saveContext()
        }
    }
    func deleteNote(_ note: Note) {
        withAnimation {
            self.delete(note)
            try? PersistenceController.shared.saveContext()
        }
    }
    
    func addFolder(_ name: String, userID: String, notes: [Note] = []) {
        withAnimation {
            let new = Folder(context: self)
            new.name = name
            new.date = Date()
            new.userID = userID
            new.notes = NSSet(array: notes)
            try? PersistenceController.shared.saveContext()
        }
    }
    
    func deleteFolder(_ folder: Folder) {
        withAnimation {
            self.delete(folder)
            try? PersistenceController.shared.saveContext()
        }
    }


}

