//
//  SignUp.swift
//  Rovle
//
//  Created by Eslam Ghazy on 13/9/23.
//

import SwiftUI
import Alamofire
import Foundation

struct SignUp: View {
    
    @ObservedObject private var viewModel: SignUpViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isRegisteredSuccessfully: Bool = false
    var body: some View {
            ScrollView{
                VStack{
                    Spacer(minLength: 30)
                    RovleNavigationView {dismiss()}
                        
                   
                        VStack(spacing: 4) {
                            Text("letsBegin!".localized)
                                .font(.chaumont(size: 55))
                                .rotationEffect(.init(degrees: -8.04))
                                .foregroundStyle(Color("light_blue"))
                            Text("fillYourDetails".localized)
                                .padding()
                                .font(.excon(12,.bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.sloganColor)
                        }
                    
                        Spacer(minLength: 80)
                        VStack{
                            UserInfoTextField(text: $viewModel.name, type: .name, keyboardType: .text)
                            UserInfoTextField(text: $viewModel.email, type: .emailLogin, keyboardType: .text)
                            //UserInfoTextField(text: $viewModel.nif, type: .nif)
                            UserInfoTextField(text: $viewModel.password, type: .password, keyboardType: .text)
                            
                            UserInfoTextField(text: $viewModel.confirmationPassword, type: .confirmPassword, keyboardType: .text)
                        }
                        .padding(.horizontal)
                        
                        NavigationLink(isActive: $isRegisteredSuccessfully) {
                            LazyView(LoginView(viewModel: LoginViewModel()))
                        } label: {
                            Text("")
                                .hidden()
                        }
                            Button {
                                viewModel.signUpNewUser()
                            } label: {
                                Text("signUp".localized)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .font(.excon(14))
                                    .disabled(viewModel.checkSignUpAvailability())
                                    .background {
                                        Color.gray
                                            .cornerRadius(30)
                                        if viewModel.checkSignUpAvailability() {
                                            Color.sloganColor
                                            .cornerRadius(30)
                                        } else {
                                            Color.gray
                                            .cornerRadius(30)
                                        }
                                    }
                                    .padding()
                            }
                            .disabled(!viewModel.checkSignUpAvailability())
                            
                    }
                    .keyboardHeight()
                    .padding(.horizontal)
                    .onReceive(viewModel.$registerSuccessfully, perform: { value in
                        if value == true {
                            setHomeRoot()
                        }
                    })
                    .background{ Color(hex: "#E1F7FF")}
                    NavigationLink(isActive: $isRegisteredSuccessfully) {
                        
                    } label: {
                        Text("")
                            .hidden()
                    }
        }
            .background{
                Color.authBackground
            }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toastView(toast: $viewModel.onError)
        .showLoader(loading: $viewModel.onLoading)
    }
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }
    
    private func setHomeRoot() {
            let windwo = UIApplication
                .shared
                .connectedScenes
                .flatMap {($0 as? UIWindowScene)?.windows ?? []}
                .first {$0.isKeyWindow}
            windwo?.rootViewController = UIHostingController(rootView: Home())
            windwo?.makeKeyAndVisible()
        }
}


struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(viewModel: SignUpViewModel())
    }
}
