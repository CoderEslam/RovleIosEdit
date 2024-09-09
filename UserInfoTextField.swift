//
//  PasswordTextField.swift
//  Rovle
//
//  Created by Sharaf on 1/13/24.
//

import SwiftUI

struct UserInfoTextField: View {
    @State private var isSecure: Bool = true
    private var type: UserInformationModel
    @Binding private var text: String
    let isDisable: Bool
    let keyboardType: KeyboardType
    var body: some View {
        if type == .newPassword || type == .password || type == .confirmPassword {
            HStack {
                Image(type.image)
                if !isSecure {
                    TextField(type.placeHolder, text: $text)
                        .font(.excon(15))
                } else {
                    SecureField(type.placeHolder, text: $text)
                        .font(.excon(15))
                   
                }
                Spacer()
                if isSecure {
                    Image(systemName: "eye")
                        .foregroundStyle(Color.buttonColor, .white)
                        .onTapGesture {
                            isSecure.toggle()
                        }
                } else {
                    Image(systemName: "eye.slash")
                        .foregroundStyle(Color.buttonColor, Color.buttonColor)
                        .onTapGesture {
                            isSecure.toggle()
                        }
                }
            }
            .padding()
            .background {
                Color.white
                    .cornerRadius(30)
            }
        } else {
            HStack {
                if type != .phone {
                    Image(type.image)
                } else {
                    Image(systemName: type.image)
                        .foregroundColor(.buttonColor)
                }
                if type == .email {
                    TextField(type.placeHolder, text: $text)
                        .font(.excon(15))
                        .disabled(isDisable)
                } else {
                    TextField(type.placeHolder, text: $text)
                        .font(.excon(15))
                        .keyboardType(keyboardType == KeyboardType.number ? .phonePad : .default)
                        .disabled(isDisable)
                }
            }
            .padding()
            .background {
                Color.white
                    .cornerRadius(30)
            }
        }
          
    }
    
    init(text: Binding<String>, type: UserInformationModel, isDisable: Bool = false , keyboardType:KeyboardType ) {
        self._text = text
        self.type = type
        self.isDisable = isDisable
        self.keyboardType = keyboardType
    }
}

#Preview {
    UserInfoTextField(text: .constant(""), type: .password, keyboardType: .text)
}
struct UserInfoTextFieldChange: View {
    @State private var isSecure: Bool = true
    private var type: UserInformationModel
    @Binding private var text: String
    
    var body: some View {
        if type == .newPassword || type == .password || type == .confirmPassword {
            HStack {
                Image(type.image)
                if !isSecure {
                    TextField(type.placeHolder, text: $text)
                    
                        .font(.excon(15))
                } else {
                    SecureField(type.placeHolder, text: $text)
                        .font(.excon(15))
                   
                }
                Spacer()
                if isSecure {
                    Image(systemName: "eye")
                        .foregroundStyle(Color.buttonColor, .white)
                        .onTapGesture {
                            isSecure.toggle()
                        }
                } else {
                    Image(systemName: "eye.slash")
                        .foregroundStyle(Color.buttonColor, Color.buttonColor)
                        .onTapGesture {
                            isSecure.toggle()
                        }
                }
            }
            .padding()
            .background {
                Color.white
                    .cornerRadius(30)
            }
        } else {
            HStack {
                Image(type.image)
                TextField(type.placeHolder, text: $text)
                    .font(.excon(15))
            }
            .padding()
            .background {
                Color.white
                    .cornerRadius(30)
            }
        }
        if type == .email {
            TextField(type.placeHolder, text: $text)
                .font(.excon(15))
                .disabled(true)
        } else {
            TextField(type.placeHolder, text: $text)
                .font(.excon(15))
        }
          
    }
    
    init(text: Binding<String>, type: UserInformationModel) {
        self._text = text
        self.type = type
    }
}

#Preview {
    UserInfoTextField(text: .constant(""), type: .email, keyboardType: .text)
}

enum KeyboardType {
    
    case number
    case text
    
}
