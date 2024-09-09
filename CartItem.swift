//
//  CartItem.swift
//  Rovle
//
//  Created by Eslam Ghazy on 29/8/23.
//

import SwiftUI

struct CartItem: View {
    
    @StateObject var viewModel: CartItemViewModel
    
    @State  var showDetails : Bool = true
    @State private var navigateToInvoice: Bool = false
    @Environment(\.dismiss)var dismiss
    @State private var isExpanding: Bool = true
    var body: some View {
        VStack {
            MainNavigationView(name: "Cart".localized) {
                dismiss()
            }
           
            ZStack {
                ScrollView{
               
                        VStack (alignment: .leading) {
                            Text("Status of your order".localized)
                                .padding(.horizontal)
                            CartItemHeader(isExpanded: $isExpanding)
                                .padding(.horizontal)
                            if isExpanding {
                                VStack (alignment: .leading){
                                    ForEach($viewModel.items ,id:\.id) { cartItem in
                                        ProductCartItem(cartItem: cartItem, roaster: viewModel.cartDetalis?.roaster ?? "") { presentation in
                                            viewModel.deleteCart(cartId: cartItem.id.wrappedValue)
                                            
                                        } updateItem: { item in
                                            viewModel.increasePresentationQuantity(presentationId: item.id, cartItemId: cartItem.wrappedValue.id)
                                            
                                        } decreaseQuantity: { item in
                                            viewModel.decreasePresentationQuantity(presentationId: item.id, cartItemId: cartItem.wrappedValue.id)
                                            
                                        }
                                        
                                    }
                                }
                                .padding(.horizontal)
                            }
                            TextField("Añade aquí una nota....".localized, text: $viewModel.note)
                                .frame(height: 90)
                                .padding()
                                .background {
                                    Color.backgroundComponents
                                        .cornerRadius(15)
                                }
                                .padding()
                            VStack (spacing: 8){
                                Text("Selecciona tipo de entrega".localized)
                                    .font(.excon(16))
                                    .foregroundColor(.sloganColor)
                                    .frame(maxWidth: .infinity,alignment:.leading)
                                    .padding([.top,.horizontal])
                                RadioButtonGroup(
                                    items: [
                                        .takeAway, .locker, .home
                                    ],
                                    addressType: $viewModel.deliveryType) { selected in
                                        withAnimation(.spring){
                                            self.viewModel.deliveryType = selected
                                        }
                                    }
                                    .foregroundColor(.sloganColor)
                                    .padding(.horizontal)
                                VStack {
                                    if let deliveryType = viewModel.deliveryType {
                                        LazyView(
                                            
                                            SelecetAddressView(
                                                savedAddress: $viewModel.savedAddressText,
                                                selectedAddress: $viewModel.selectedAddress,
                                                locker: $viewModel.lockersText,
                                                selectedLocker: $viewModel.selectedLocker,
                                                coffeeShops: $viewModel.coffeeShopsText,
                                                selectedCoffeShop: $viewModel.selectedCoffeeShops,
                                                zipCode: $viewModel.zipCodingChallenge.value,
                                                name: $viewModel.userName,
                                                email: $viewModel.email,
                                                number: $viewModel.phone,
                                                addressType: $viewModel.deliveryType,
                                                currentAddress: $viewModel.currentAddress,
                                                countries: $viewModel.countries,
                                                provinces: $viewModel.provinces,
                                                cities: $viewModel.cities,
                                                selectedCountry: $viewModel.selectedCountry,
                                                selectedProvinces: $viewModel.selectedProvince,
                                                selectedCities: $viewModel.selectedCity, isCoffeeShopsOptionsLimited: $viewModel.isCoffeeShopsLimited,
                                                isLockerOptionsLimited:$viewModel.isLockerLimited
                                            ).onAppear {
                                                subscriber()
                                            }.padding()
                                        )
                                    }
                                }.ignoresSafeArea(.keyboard)
                            }.background {
                                Color.backgroundComponents
                                    .cornerRadius(15)
                            } .padding()
                        }
                    
                    VStack{
                        Button {
                            viewModel.tryCreateOrder()
                        } label: {
                            HStack(alignment: .center) {
                                Text("")
                                Text("Realizar Pedido")
                                
                                Text("")
                            }
                            .frame(maxWidth: .infinity, maxHeight:45)
                            .padding()
                            .cornerRadius(10)
                        }
                        .background {
                            !viewModel.canGoPayAvailable() ? Color.gray.cornerRadius(20) : Color.buttonColor.cornerRadius(20)
                        }
                        .disabled(!viewModel.canGoPayAvailable())
                        
                        .foregroundStyle(Color.white)
                    }
                    .padding()
                }
                .scrollDismissesKeyboard(.immediately)
                
                .disabled(viewModel.onError?.title == "Unauthenticated")

               
                if !viewModel.isAuthorized {
                    LazyView(UnAuthunticatedView(back: $viewModel.backToHome))
                }
                
                if viewModel.canCreateNewAddress {
                   LazyView( CustomPopAskingQuestionCartItem(createNewAddress: $viewModel.createNewAddress, cancel: $viewModel.neglectAddressAndCreateOrder, question: "Desea guardar esta dirección para futuras compras?", firstChoice: "Confirmar", secondChoice: "Cancelar"))
                }
            }
            .padding(.top, 8)
            .padding([.leading, .trailing, .bottom])
            .navigationBarBackButtonHidden()
            .onReceive(viewModel.$dismiss, perform: { value in
                if value == true {
                    dismiss()
                }
            })

            .onReceive(viewModel.$isUserLogin, perform: { value in
                if value == true {
                    setLoginRoot()
                }
            })
            .onReceive(viewModel.$backToHome, perform: { value in
                guard  value == true else { return }
                dismiss()
            })
            .onReceive(viewModel.$order) { value in
                guard  let value else { return }
                navigateToInvoice.toggle()
            }
            .onReceive(viewModel.$createNewAddress, perform: { value in
                guard value == true else { return }
                guard viewModel.deliveryType == .home else { return }
                viewModel.canCreateNewAddress = false
                viewModel.addNewAddress()
                
            })
            .onReceive(viewModel.$neglectAddressAndCreateOrder, perform: { value in
                guard value == true else { return }
                viewModel.canCreateNewAddress = false
                viewModel.collectTheOrder()
            })
           
            .onReceive(viewModel.$selectedCoffeeShops, perform: { value in
                guard let value else { return }
                viewModel.getCoffeeShopsSelected()
            })
            .onReceive(viewModel.$selectedAddress) { value in
                guard let address = value else { return }
                viewModel.selectOldAddress()
            }
            .onReceive(viewModel.$selectedLocker, perform: { value in
                guard let locker = value else { return }
                viewModel.selectLocker()
            })
            .onReceive(viewModel.$deliveryType) { value in
                viewModel.resetAddressData()
            }
            .onReceive(viewModel.$phone, perform: { value in
                guard value.isNotEmptyOrWhitSpace else { return }
                viewModel.canGoPayAvailable()
            })
            .fullScreenCover(isPresented: $navigateToInvoice, content: {
                if let orderDetalis = viewModel.order {
                    LazyView(
                        ConfirmOrderView(orderData: orderDetalis, openFromCreateOrder: true))
                }
            })
            .onAppear {
                viewModel.getAllAddresses()
                viewModel.getCartDetails()
            }
            VStack {
                
            }
            .showLoader(loading: $viewModel.onLoading)
        }
    }
    
    init(viewModel: CartItemViewModel) {
        self._viewModel = StateObject(wrappedValue: CartItemViewModel(cartId: viewModel.cartId, providerId: viewModel.providerId, providerName: viewModel.providerName))
    }
    
    func subscriber() {
        viewModel.zipCodingChallenge.sink { value in
            if value.count == 5 {
                viewModel.checkzipCode()
            }
        }.store(in: &viewModel.cancellable)
    }
    private func setLoginRoot() {
        let windwo = UIApplication
            .shared
            .connectedScenes
            .flatMap {($0 as? UIWindowScene)?.windows ?? []}
            .first {$0.isKeyWindow}
        windwo?.rootViewController = UIHostingController(rootView: LazyView(LoginView(viewModel: LoginViewModel())))
        windwo?.makeKeyAndVisible()
    }
}





//struct CartItem_Previews: PreviewProvider {
//    static var previews: some View {
//        CartItem(viewModel: CartItemViewModel(cartId: "", providerId: ""))
//    }
//}


enum DeliveryType: String {
    case takeAway = "take_away"
    case locker = "locker"
    case home = "delivery"
}

extension DeliveryType {
    var title: String {
        switch self {
        case .takeAway:
            "Para llevar"
        case .locker:
            "Locker"
        case .home:
            "Domicilio"
        }
    }
}

struct CartItemHeader: View {
    
    @Binding private var isExpanded: Bool
    var body: some View {
        HStack {
            Text("Más detalles")
                .padding(8)
                .font(.excon(16, .bold))
            Spacer()
            Image(systemName: isExpanded ? "chevron.down.square" : "chevron.up.square")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(8)
        }
        
        .foregroundColor(.white)
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()

            }
        }
        .background {
            Color.sloganColor.cornerRadius(20)
        }
    }
    init(isExpanded: Binding<Bool>) {
        self._isExpanded = isExpanded
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
