//
//  LoginViewModel.swift
//  CoreNotes
//

import SwiftUI
import Firebase


//this class manages logic and data for the Login View. Uses ObservableObject because it publishes changes when they occur in Login View. @Published property wrapper is needed for variables so that when that var is modified, the change is reflected in the View.
class LoginViewModel: ObservableObject{
        
    //Signup variables
    @Published var isNewUser = false 
    @Published var registerEmail = ""
    @Published var registerPassword = ""
    @Published var reEnterPassword = ""

    //Login variables
    @Published var email = ""
    @Published var password = ""
    
    @Published var errorMsg = ""
    @Published var error = false
    
    @Published var userID: String?
    
    //AppStorage used to persistently store login status. Login status is by default false until the user logs in. "log_status" is the name of the key which stores true or false
    @AppStorage("log_Status") var status = false
    let keychainManager = KeyChainManager()
    
    func loginUser(){
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] (result, err) in
            if let error = err{
                errorMsg = error.localizedDescription
                self.error.toggle()
                return
            }
    
            guard let _ = result else {
                errorMsg = "Please try again Later !"
                error.toggle()
                return
            }
            
            if let userID = result?.user.uid {
                keychainManager.saveUserID(userID: userID)
                self.userID = userID
              }
            print(userID!)
            
            print("Sucess")
            withAnimation{status = true} // switches to Home View. Look at ContentView for reference 
        }
        
    }
    
    func resetPassword(){
        Auth.auth().sendPasswordReset(withEmail: email) {[self] (err) in
            if let error = err{
                errorMsg = error.localizedDescription
                self.error.toggle()
                return
            }
            errorMsg = "Reset Link sent successfully!"
            error.toggle()
        }
    }
    
    func registerUser(){
        //checks that passwords match
        if reEnterPassword == registerPassword{
            Auth.auth().createUser(withEmail: registerEmail, password: reEnterPassword) { [self]
                (result, err) in
                
                if let error = err{
                    errorMsg = error.localizedDescription
                    self.error.toggle()
                    return
                }
                
                guard let _ = result else {
                    errorMsg = "Please try again Later !"
                    error.toggle()
                    return
                }
                
                if let userID = result?.user.uid {
                   keychainManager.saveUserID(userID: userID)
                    
                    self.userID = userID //
                  }
                print(userID!)
                
                print("Sucess")
                errorMsg = "Account Created!"
                error.toggle()
                withAnimation{isNewUser = false} //not sure iff neccesary since by default it is false 
            }
          }
        else {
            errorMsg="Passwords do not match"
            error.toggle()
        }
    }
}

