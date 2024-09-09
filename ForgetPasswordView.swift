//
//  ForgetPasswordView.swift
//  Rovle
//
//  Created by Eslam Ghazy on 29/9/23.
//

import SwiftUI
import StepperView

struct ForgetPasswordView: View {
    
    @StateObject private var viewModel: ForgetPasswordViewModel
    @State private var navigateToOtp: Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack{
            RovleNavigationView {
                dismiss()
            }
            .padding(.vertical)
            ProgressViewProgress(progressNumber: $viewModel.progressValue)
                .padding(.top)
            VStack{
                HStack{
                    Spacer()
                    Text("Recuperar \ncontraseña")
                        .padding()
                        .foregroundColor(Color.buttonColor)
                        .font(.chaumont(size: 50))
                        .bold()
                        .fixedSize()
                        .italic()
                        .rotationEffect(.init(degrees: -3.04))
                    Spacer()
                }
                Text("Ingresa tu correo electrónico \n para enviar en código OTP.")
                    .font(.excon(12))
                    .foregroundColor(.sloganColor)
                Spacer()
                UserInfoTextField(text: $viewModel.email, type: .email, keyboardType: .number)
            }
          
                //.padding()
            Button {
                viewModel.verifyEmail()
            } label: {
                Text("Enivar")
                    .padding()
                    .foregroundColor(.white)
                    .font(.excon(16))
                    .frame(maxWidth: .infinity)
                    .background {
                        if viewModel.email.isValidEmail() {
                            Color.sloganColor
                                .cornerRadius(30)
                        } else {
                            Color.gray
                                .cornerRadius(30)
                        }
                    }
                   
            }
            .disabled(!viewModel.email.isValidEmail())
            .padding(.bottom)
            .padding(.top, 8)

        }
        .padding()
       
        .keyboardHeight()
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
        .fullScreenCover(isPresented: $navigateToOtp, onDismiss: {
            navigateToOtp = false
        }, content: {
            OtpFormFieldView(viewModel: VerifyOtpViewModel(email: viewModel.email))
        })
        .showLoader(loading: $viewModel.onLoading)
        .toastView(toast: $viewModel.onError)
        .navigationBarBackButtonHidden()
        
    }
    
    init(viewModel: ForgetPasswordViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView(viewModel: ForgetPasswordViewModel())
    }
}
