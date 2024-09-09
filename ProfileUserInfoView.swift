//
//  UserInfo.swift
//  Rovle
//
//  Created by Sharaf on 12/4/23.
//

import SwiftUI

struct ProfileUserInfoView: View {
    @Binding private var userInfo: UserLoginResponse
    @Binding private var didTapOnPassword: Bool
    @Binding private var oldPassword: String
    @Binding private var newPassword: String
    @Binding private var confirmPassword: String
    var body: some View {
        VStack{
            
          //  UserInfoTextField(text: $userInfo.phone, type: .phone)
            UserInfoTextField(text: $userInfo.name, type: .name, keyboardType: .text)
            UserInfoTextField(text: $userInfo.email, type: .email, isDisable:  true, keyboardType: .text)
          //  UserInfoTextField(text: $userInfo.nif, type: .nif)
            UserInfoTextField(text: $oldPassword, type: .password, keyboardType: .text)
            UserInfoTextField(text: $newPassword, type: .newPassword, keyboardType: .text)
            UserInfoTextField(text: $confirmPassword, type: .confirmPassword, keyboardType: .text)
            
            HStack {
                Spacer()
                Button(action: {
                    didTapOnPassword.toggle()
                }, label: {
                    Text("Modificar".localized)
                        .padding([.horizontal,.bottom])
                        
                        .foregroundColor(.gray)
                })
            }
        }
    }
    
    init(
        userInfo: Binding<UserLoginResponse>,
        didTapOnPassword: Binding<Bool>,
        oldPassword: Binding<String>,
        newPassword: Binding<String>,
        confirmPassword: Binding<String>
    ) {
        self._userInfo = userInfo
        self._didTapOnPassword = didTapOnPassword
        self._oldPassword = oldPassword
        self._newPassword = newPassword
        self._confirmPassword = confirmPassword
    }
}

//#Preview {
//    ProfileUserInfoView(userInfo: .constant(.sample), didTapOnPassword: .constant(false))
//}
