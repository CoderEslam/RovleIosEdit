//
//  AddressCatalogTextFieldView.swift
//  Rovle
//
//  Created by Sharaf on 3/27/24.
//

import SwiftUI

struct AddressCatalogTextFieldView: View {
    let isForAddressCatalog: Bool
    let title: String
    @Binding private var text: String
    let type: UserInformationModel
    let isNotAvailableToEdit: Bool
    let keyboardType: KeyboardType
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isForAddressCatalog{
                Text(title)
                    .foregroundColor(.sloganColor)
            }
            UserInfoTextField(text: $text, type: type, isDisable: isNotAvailableToEdit,keyboardType : keyboardType)
            
        }
    }
    
    init(isForAddressCatalog: Bool = false,
         title: String,
         text: Binding<String>,
         type: UserInformationModel,
         isNotAvailableToEdit: Bool = false,
         keyboardType : KeyboardType
    ) {
        self.isForAddressCatalog = isForAddressCatalog
        self.title = title
        self._text = text
        self.type = type
        self.isNotAvailableToEdit = isNotAvailableToEdit
        self.keyboardType = keyboardType
    }
}

#Preview {
    AddressCatalogTextFieldView(isForAddressCatalog: true, title: "C.P.", text: .constant(""), type: .zipCode, isNotAvailableToEdit: false, keyboardType: .text )
}
