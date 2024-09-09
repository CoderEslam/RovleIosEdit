//
//  SelecetAddressView.swift
//  Rovle
//
//  Created by Sharaf on 11/15/23.
//

import SwiftUI

struct SelecetAddressView: View {
    @Binding private var zipCode: String
    @Binding private var name: String
    @Binding private var email: String
    @Binding private var number: String
    @Binding private var currentAddress: String
    @Binding private var deliveryType: DeliveryType?
    @Binding private var locker: [DropdownMenuOption]
    @Binding private var coffeeShops:[DropdownMenuOption]
    @Binding private var savedAddress: [DropdownMenuOption]
    @Binding private var selectedAddress: DropdownMenuOption?
    @Binding private var selectedLocker: DropdownMenuOption?
    @Binding private var selectedCoffeeShop: DropdownMenuOption?
    @Binding private var selectedCountry: DropdownMenuOption?
    @Binding private var selectedProvince: DropdownMenuOption?
    @Binding private var selectedCity: DropdownMenuOption?
    @Binding private var countries: [DropdownMenuOption]
    @Binding private var provinces: [DropdownMenuOption]
    @Binding private var cities: [DropdownMenuOption]
    @State private var profile: UserLoginResponse? = nil
    @Binding private var isCoffeeShopsOptionsLimited: Bool
    @Binding private var isLockerOptionsLimited: Bool
    @State private var isValid: Bool = true
    @State private var errorMessage: String = ""
    
    // @ObservedObject private var viewModel: SelectAddressViewModel
    var body: some View {
        
        VStack{
            if deliveryType == .home {
                AddressCatalogOptionTextView(title: "Direcciones guardadas".localized, selected: $selectedAddress, options: $savedAddress, isFromAddress: false)
                AddressCatalogTextFieldView(title: "C.P.".localized, text: $zipCode, type: .zipCode , keyboardType: .number)
                
                AddressCatalogOptionTextView(title: "selectedCountry".localized, selected: $selectedCountry, options: $countries, isFromAddress: false)
                AddressCatalogOptionTextView(title: "selectedProvince".localized, selected: $selectedProvince, options: $provinces, isFromAddress: false)
                AddressCatalogOptionTextView(title: "selectedCity".localized, selected: $selectedCity, options: $cities, isFromAddress: false)

            } else if deliveryType == .locker {
                VStack(alignment: .leading) {
                    AddressCatalogTextFieldView(title: "C.P.".localized, text: $zipCode, type: .zipCode, keyboardType: .number)
                        .frame(maxWidth: .infinity,alignment:.leading)
                        .padding(.top,10)
                    
                    AddressCatalogOptionTextView(title: "Lockers".localized, selected: $selectedLocker, options: $locker, isFromAddress: false)
                    if isLockerOptionsLimited {
                        Text("No hay oficinas o lockers en este C.P.")
                            .foregroundColor(.red)
                    }
                }
            } else if deliveryType == .takeAway {
                VStack(alignment: .leading) {
                    AddressCatalogTextFieldView(title: "C.P.".localized, text: $zipCode, type: .zipCode, keyboardType: .number)
                    AddressCatalogOptionTextView(title: "coffeeShop".localized, selected: $selectedCoffeeShop, options: $coffeeShops, isFromAddress: false)
                    if isCoffeeShopsOptionsLimited {
                        Text("No hay tiendas en este C.P")
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical)
                
                    
            }
            VStack{
                if deliveryType == .home {
                    AddressCatalogTextFieldView(title: "address".localized, text: $currentAddress, type: .address, keyboardType: .text)
                        .padding(.bottom)
                }
                AddressCatalogTextFieldView(title: "name".localized, text: $name, type: .name, keyboardType: .text)
                    .padding(.bottom)
                AddressCatalogTextFieldView(title: "123123".localized, text: $number, type: .phone, keyboardType: .number)
                    .onChange(of: number, perform: { newValue in
                        isValid = validateSpanishPhoneNumber(phoneNumber: newValue)
                        errorMessage = isValid ? "" : "Número de teléfono no válido"
                    })
                    .padding(.bottom)
                if !isValid {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                AddressCatalogTextFieldView(title: "email".localized, text: $email , type: .email, keyboardType: .text)
            }
           
        }
        .padding(.vertical,8)
        .frame(maxWidth: .infinity,alignment:.leading)
        
        //            .showLoader(loading: $viewModel.onLoading)
        //            .toastView(toast: $viewModel.onError)
        
    }
    
    init(
        savedAddress: Binding<[DropdownMenuOption]> ,
        selectedAddress: Binding<DropdownMenuOption?>,
        locker: Binding<[DropdownMenuOption]>,
        selectedLocker: Binding<DropdownMenuOption?>,
        coffeeShops:Binding<[DropdownMenuOption]>,
        selectedCoffeShop: Binding<DropdownMenuOption?>,
        zipCode: Binding<String>,
        name: Binding<String>,
        email: Binding<String>,
        number: Binding<String>,
        addressType: Binding<DeliveryType?>,
        currentAddress: Binding<String>,
        countries: Binding<[DropdownMenuOption]> ,
        provinces: Binding<[DropdownMenuOption]> ,
        cities: Binding<[DropdownMenuOption]>,
        selectedCountry: Binding<DropdownMenuOption?>,
        selectedProvinces: Binding<DropdownMenuOption?>,
        selectedCities: Binding<DropdownMenuOption?>,
        isCoffeeShopsOptionsLimited: Binding<Bool>,
        isLockerOptionsLimited: Binding<Bool>
    ) {
        self._savedAddress = savedAddress
        self._selectedAddress = selectedAddress
        self._zipCode = zipCode
        self._name = name
        self._currentAddress = currentAddress
        self._coffeeShops = coffeeShops
        self._email = email
        self._number = number
        self._deliveryType = addressType
        self._locker = locker
        self._selectedCoffeeShop = selectedCoffeShop
        self._selectedLocker = selectedLocker
        self._coffeeShops = coffeeShops
        self._locker = locker
        self._countries = countries
        self._provinces = provinces
        self._cities = cities
        self._selectedCountry = selectedCountry
        self._selectedProvince = selectedProvinces
        self._selectedCity = selectedCities
        self._isCoffeeShopsOptionsLimited = isCoffeeShopsOptionsLimited
        self._isLockerOptionsLimited = isLockerOptionsLimited
    }
    
    
    // Validation function for Spanish phone number
    private func validateSpanishPhoneNumber(phoneNumber: String) -> Bool {
        let phoneRegex = "^(\\+34|0034|34)?[6|7|9][0-9]{8}$"  // Spanish phone number format
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
}

//#Preview {
//    SelecetAddressView(zipCode: .constant(""), name: .constant(""), email: .constant(""),  number: .constant(""), addressType: .home, locker: [], address: .constant(""))
//}
