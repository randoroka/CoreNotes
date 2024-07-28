//
//  Login.swift
//  CoreNotes
//


import SwiftUI

struct Login: View {
    var screen=NSScreen.main?.visibleFrame
    
    //email and password fields. State wrapper to manage the variables just for this view
    @State var email=""
    @State var password=""
    @State var keepLogged=false

    @State var alert = false
    @State var switchTest = false
    
    //creates the intial instance of the view model so that the view can access the data and will be modified according to the @Published variables
    @StateObject var loginData = LoginViewModel()
    
    
    var body: some View{
        HStack(spacing:0){
            Spacer(minLength:0)
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:100, height:100)
                Text("CoreNotes")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                
                //sign in view
                if !loginData.isNewUser{
                    CustomTextField(value: $loginData.email, hint: "Email")
                    
                    CustomTextField(value: $loginData.password, hint: "Password")
                        
                    HStack{
                        Toggle("", isOn: $keepLogged)
                            .labelsHidden()
                            .toggleStyle(CheckboxToggleStyle())
                        Text("Stay Logged In")
                            .foregroundColor(.black)
                        Spacer(minLength:0)
                        
                        Button(action: loginData.resetPassword, label: {
                            Text("Forgot Password?")
                                .foregroundColor(.black)
                                .underline(true,color:Color.black)
                        })
                            .disabled(loginData.email == "")
                            .buttonStyle(PlainButtonStyle())
                            .padding(.top)
                    }
                    
                    Button(action: loginData.loginUser, label: {
                        HStack{
                            Spacer()
                            Text("Login")
                            Spacer()
                            Image(systemName: "arrow.right")
                            
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .background(Color("test"))
                        .cornerRadius(2)
                    })
                        .padding(.top, 10)
                    //makes sure the fields aren't empty
                    .disabled(loginData.email == "" || loginData.password == "")
                    
                    HStack{
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        Button(action: {
                            withAnimation{loginData.isNewUser.toggle()}
                        }, label: {
                             Text("Sign Up")
                                .foregroundColor(.blue)
                                .underline(true,color:Color.black)
                            
                                .padding(.vertical, 10)
                        })
                            .buttonStyle(PlainButtonStyle())
                    }
                }
                // sign up view
                else {
        
                    CustomTextField(value: $loginData.registerEmail, hint: "Email")
                    
                    CustomTextField(value: $loginData.registerPassword, hint: "Password")
                    
                    CustomTextField(value: $loginData.reEnterPassword, hint: "Re-Enter Password")
                        
                    HStack{
                        Toggle("", isOn: $keepLogged)
                            .labelsHidden()
                            .toggleStyle(CheckboxToggleStyle())
                        Text("Stay Logged In")
                            .foregroundColor(.black)
                        Spacer(minLength:0)
                        
                       
                    }
                    
                    Button(action: loginData.registerUser, label: {
                        HStack{
                            Spacer()
                            Text("Sign Up")
                            Spacer()
                            Image(systemName: "arrow.right")
                            
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .background(Color("test"))
                        .cornerRadius(2)
                    })
                        .padding(.top, 10)
                    //makes sure the fields aren't empty
                        .disabled(loginData.registerEmail == "" || loginData.registerPassword == "" || loginData.reEnterPassword == "" )
                    
                    HStack{
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Button(action: {
                            withAnimation{loginData.isNewUser.toggle()}
                        }, label: {
                             Text("Sign in")
                                .foregroundColor(.blue)
                                .underline(true,color:Color.black)
                                .padding(.vertical, 10)
                        })
                            .buttonStyle(PlainButtonStyle())
                                                  
                    }
                }
                
                
            }
            .textFieldStyle(PlainTextFieldStyle())
            .buttonStyle(PlainButtonStyle())
            .padding()
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .zIndex(1)
            VStack{
                Spacer()

            }
            .frame(width: (screen!.width / 1.8) / 2)
            .background(Color("test"))
            .zIndex(0)
            
        }
        .ignoresSafeArea(.all, edges: .all)
        .frame(width: screen!.width / 1.8, height: screen!.height - 100)
        .preferredColorScheme(.light)
        .alert(isPresented: $loginData.error, content: {
            Alert(title: Text("Message"), message: Text(loginData.errorMsg), dismissButton:
                        .destructive(Text("OK"), action: {
                
            }))
        })
    }
    
}


//shows what view would look like without having to run app
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

struct CustomTextField: View {
    //Binding wrapper needed for when value interacts with State variables in Login structure
    @Binding var value: String
    var hint: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6, content: {
            Text(hint)
                .font(.caption)
                .foregroundColor(.gray)
            
            ZStack{
                if hint == "Email"{
                    TextField(hint == "Email" ? "example@gmail.com" :
                                "**********", text: $value)
                }
                else{
                    SecureField("**********", text: $value )
                }
            }
                .padding(.vertical,10)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius:2).stroke(Color.gray.opacity(0.7), lineWidth:1))
        })
    }
}
