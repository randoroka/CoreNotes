//
//  Home.swift
//  CoreNotes
//


import SwiftUI

struct Home: View {
    

    var body: some View {
        NavigationView{
            Sidebar()
                .frame(minWidth:260)
            Text("No folder selected")
                .frame(minWidth:250)
                .toolbar{
                    ToolbarItem(placement: .primaryAction){
                        HStack{
                            Text("  ")
                            Image("logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:30, height:30)
                            Text("CoreNotes")
                                .font(.system(size: 20, weight: .semibold))
                        }
                    }
                }
            Text("No note selected")
        }
            
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
