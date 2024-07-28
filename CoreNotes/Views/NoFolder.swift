//
//  NoFolder.swift
//  CoreNotes
//
//  Created by Ariel on 6/18/24.
//

import SwiftUI

struct NoFolder: View {
    var body: some View {
        NavigationView{
            Text("No folder selected")
            Text("No note selected")
        }
    }
}

struct NoFolder_Previews: PreviewProvider {
    static var previews: some View {
        NoFolder()
    }
}
