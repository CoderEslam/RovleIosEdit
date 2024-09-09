//
//  AddressCatalogDetailsView.swift
//  Rovle
//
//  Created by Sharaf on 3/27/24.
//

import SwiftUI

struct AddressCatalogDetailsView: View {
    @StateObject private var viewModel: AddressCatalogDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var keyboardHeight: CGFloat = 0
    @State private var isValid: Bool = true
    @State private var errorMessage: String = ""
    @Binding private var isdismiss: Bool
    var body: some View {
        VStack {
            MainNavigationView(name: viewModel.addressId == nil ? "addressDetails".localized : "Editar Dirección") {
                dismiss()
            }
            .padding(.top, 30)
            .padding(.horizontal)
            ScrollView {
                VStack {
                    
                    AddressCatalogTextFieldView(
                        isForAddressCatalog: true,
                        title: "C.P.",
                        text: $viewModel.zipCode  ,
                        type: .zipCode,
                        keyboardType: .number
                    )
                    AddressCatalogTextFieldView(
                        isForAddressCatalog: true,
                        title: "Dirección",
                        text: $viewModel.address  ,
                        type: .address,
                        keyboardType: .text
                    )
                    
                    AddressCatalogOptionTextView(
                        title: "selectedCountry".localized,
                        selected: $viewModel.selectedCountry,
                        options: $viewModel.countries, isFromAddress: true
                    )
                    AddressCatalogOptionTextView(
                        title: "selectedProvince".localized,
                        selected: $viewModel.selectedProvince,
                        options: $viewModel.provinces, isFromAddress: true
                    )
                    AddressCatalogOptionTextView(
                        title: "selectedCity".localized,
                        selected: $viewModel.selectedCity,
                        options: $viewModel.cities, isFromAddress: true
                    )
                    
                    AddressCatalogTextFieldView(
                        isForAddressCatalog: true,
                        title: "Usuario".localized,
                        text: $viewModel.userName  ,
                        type: .name,
                        isNotAvailableToEdit: viewModel.addressId == nil ? false : true, keyboardType: .text
                    )
                    AddressCatalogTextFieldView(
                        isForAddressCatalog: true,
                        title: "Teléfono".localized,
                        text: $viewModel.phone,
                        type: .phone,
                        keyboardType: .number
                    )
                    
                    AddressCatalogTextFieldView(
                        isForAddressCatalog: true,
                        title: "email".localized,
                        text: $viewModel.email  ,
                        type: .email,
                        isNotAvailableToEdit: viewModel.addressId == nil ? false : true,
                        keyboardType: .text
                    )
                    HStack(spacing: 8) {
                        Button(action: {
                            if viewModel.addressId == nil {
                                dismiss()
                            } else {
                                viewModel.deleteOldAddress()
                            }
                        }, label: {
                            Text(viewModel.addressId == nil ? "cancel".localized : "Borrar")
                                .padding()
                                .padding(.horizontal)
                                .padding(.horizontal)
                                .font(.excon(14))
                                .foregroundColor(.white)
                                .background(Color.sloganColor)
                                .cornerRadius(25)
                                .fixedSize()
                             
                        })
                     
                        Button(action: {
                            viewModel.handleWithConfirmButton()
                        }, label: {
                            Text(viewModel.addressId == nil ?"confirmer".localized : "edit".localized)
                                .padding()
                                .padding(.horizontal)
                                .padding(.horizontal)
                                .font(.excon(14))
                                .fixedSize()
                                .foregroundColor(.white)
                                .background(viewModel.canSelectConfirm() ?  Color.buttonColor :  Color.gray)
                               
                                .cornerRadius(25)
                        })
                        .disabled(!viewModel.canSelectConfirm())
                    }
                    .padding()
                }
                .padding()
                .padding(.horizontal)
                .keyboardHeight()
                .onReceive(viewModel.$didAddressAdded) { value in
                    guard value == true else { return }
                    dismiss()
                }
                .onReceive(viewModel.$didAddressDeleted) { value in
                    guard value == true else { return }
                    dismiss()
                }
            }
            
//            .background {
//                Color.backgroundComponents
//            }
//            .ignoresSafeArea(.all, edges: [.top,.bottom])
        }
        .background {
            Color.backgroundComponents
        }
        .ignoresSafeArea(.all, edges: [.top,.bottom])
        .onReceive(viewModel.$zipCode, perform: { value in
            guard value.count == 5 else { return }
            viewModel.filterWithZip()
        })
//        .onReceive(viewModel.$didAddressDeleted, perform: { value in
//            guard value == true else { return }
//            dismiss()
//        })
//        
//        .onReceive(viewModel.$selectedCountry, perform: { value in
//            guard let country = value else { return }
//            viewModel.getProvince(for: country.id)
//        })
//        .onReceive(viewModel.$selectedProvince, perform: { value in
//            guard let province = value else { return }
//            viewModel.getCities(for: province.id)
//        })
        .navigationBarBackButtonHidden()
        .showLoader(loading: $viewModel.onLoading)
        .onDisappear(perform: {
            isdismiss = true
        })
        .toastView(toast: $viewModel.onError)
    }
    
    init(viewModel: AddressCatalogDetailsViewModel,  isdismiss: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isdismiss = isdismiss
    }
    

    
}


#Preview {
    AddressCatalogDetailsView(viewModel: AddressCatalogDetailsViewModel(), isdismiss: .constant(true))
}
