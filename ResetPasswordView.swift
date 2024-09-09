//
//  ResetPasswordView.swift
//  Rovle
//
//  Created by Sharaf on 3/26/24.
//

import SwiftUI
import PopupView
struct ResetPasswordView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ResetPasswordViewModel
    @State private var navigateToOtp: Bool = false
    
    var body: some View {
        
                VStack {
                    RovleNavigationView {
                        dismiss()
                    }
                    .padding(.top, 20)
                    
                    ProgressViewProgress(progressNumber: .constant(3))
                        
                    HStack{
                        Text("recoverYourPassword".localized)
                            .padding()
                            .bold()
                            .foregroundColor(Color.buttonColor)
                            .font(.chaumont(size: 60))
                            .fixedSize()
                            .italic()
                            .rotationEffect(.init(degrees: -8.04))
                    }
                    Text("fillYourNewPasswordAndItMustBeDifferentThePreviousOne".localized)
                        .font(.excon(16))
                        .foregroundColor(.sloganColor)
                        .multilineTextAlignment(.center)
                    Spacer()
                    VStack{
                        UserInfoTextField(text: $viewModel.password, type: .password, keyboardType: .text)
                        UserInfoTextField(text: $viewModel.confirmPassword, type: .confirmPassword, keyboardType: .text)
                            .padding(.vertical, 8)
                        
                        Button {
                            viewModel.resetPassword()
                        } label: {
                            Text("restorePassword".localized)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .font(.excon(16))
                                .foregroundColor(.white)
                                .background {
                                    if viewModel.checkResetButtonAvailable() {
                                        Color.sloganColor
                                            .cornerRadius(30)
                                    } else {
                                        Color.gray
                                            .cornerRadius(30)
                                    }
                                }
                                .padding(.vertical)
                            
                        }
                        .disabled(!viewModel.checkResetButtonAvailable())
                    }
                   
                    
                }
                .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
      
                Color.buttonColor.opacity(0.09)
            
        }
        .ignoresSafeArea()
        .onReceive(viewModel.$onSuccess, perform: { value in
            if value == true {
                navigateToOtp = true
            }
        })
        .popup(isPresented: $navigateToOtp) {
            PopupView(message:  "passwordIsCreatedSuccessfully".localized, subTitle: "Bien", buttonTitle:"Terminar") {
                Router.shared.setLoginRoot()
            }
        } customize: {
            $0
                .type(.floater())
                .position(.center)
                .animation(.spring())
                .closeOnTapOutside(false)
                .backgroundColor(.black.opacity(0.6))
        }
        .showLoader(loading: $viewModel.onLoading)
        .toastView(toast: $viewModel.onError)
        .keyboardHeight()
        .navigationBarBackButtonHidden()
    }
    init(viewModel: ResetPasswordViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
}

#Preview {
    ResetPasswordView(viewModel: ResetPasswordViewModel(otp: "", email: ""))
}
