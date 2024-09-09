//
//  LoginView.swift
//  Rovle
//
//  Created by Eslam Ghazy on 28/9/23.
//

import SwiftUI
import Foundation
import Alamofire

struct LoginView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: LoginViewModel
    var body: some View {
        NavigationView {
            VStack{
               
                RovleNavigationView {dismiss()}

                .padding()
                VStack(spacing: 4) {
                    Text("letsBegin!".localized)
                        .font(.chaumont(size: 55))
                        .rotationEffect(.init(degrees: -8.04))
                        .foregroundStyle(Color("light_blue"))
                    Text("fillYourDetailsLogin".localized)
                        .padding()
                        .font(.excon(12,.bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.sloganColor)
                }
                Spacer()
                VStack {
                    VStack(alignment: .leading, spacing: 16){
                        UserInfoTextField(text: $viewModel.email, type: .emailLogin, keyboardType: .text)
                            .padding(.vertical, 2)
                        UserInfoTextField(text: $viewModel.password, type: .password, keyboardType: .text)
                        
                        NavigationLink {
                            ForgetPasswordView(viewModel: ForgetPasswordViewModel())
                        } label: {
                            Text("forgetYourPassword?".localized)
                                .foregroundColor(Color.sloganColor)
                                .font(.excon(14))
                                .underline()
                                .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    Button {
                        viewModel.login()
                    } label: {
                        Text("login".localized)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .font(.excon(14))
                            .disabled(viewModel.checkLoginAvailability())
                            .background {
                                Color.gray
                                    .cornerRadius(30)
                                if viewModel.checkLoginAvailability() {
                                    Color.sloganColor
                                    .cornerRadius(30)
                                } else {
                                    Color.gray
                                    .cornerRadius(30)
                                }
                            }
                            .padding()
                    }
                    .disabled(!viewModel.checkLoginAvailability())

                }
                NavigationLink {
                    SignUp(viewModel: SignUpViewModel())
                } label: {
                    Text("haveNoAccount".localized)
                        .foregroundColor(.sloganColor)
                        .font(.excon(13,.bold))
                        .underline()
                        
                }
                .padding()
                
                Button(action: {
                    setHomeRoot()
                }, label: {
                    Text("continueAsGuest".localized)
                        .foregroundColor(Color.buttonColor)
                        .font(.excon(14, .medium))
                })
                Spacer()
            }
            .padding(.top, 30)
            .background{ Color(hex: "#E1F7FF")}
            .ignoresSafeArea(.all, edges: [.top, .bottom])
        }
        .navigationBarBackButtonHidden()
        .showLoader(loading: $viewModel.onLoading)
        .toastView(toast: $viewModel.onError)
        .onReceive(viewModel.$presentHome) { value in
            if value == true {
                setHomeRoot()
            }
        }
    }
    
    init(viewModel: LoginViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    private func setRegisterRoot() {
            let windwo = UIApplication
                .shared
                .connectedScenes
                .flatMap {($0 as? UIWindowScene)?.windows ?? []}
                .first {$0.isKeyWindow}
            windwo?.rootViewController = UIHostingController(rootView: SignUp(viewModel: SignUpViewModel()))
            windwo?.makeKeyAndVisible()
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
