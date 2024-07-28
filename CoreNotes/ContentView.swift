//
//  ContentView.swift
//  CoreNotes
//
//  Created by Ariel on 12/24/22.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {

    var screen=NSScreen.main?.visibleFrame
   
    @AppStorage("log_Status") var status = false
    var body: some View{
        if status{
            Home()
        }
        else{
            Login()
        }

    }
  
}
