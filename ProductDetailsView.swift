//
//  ProductDetailsView.swift
//  Rovle
//
//  Created by Eslam Ghazy on 4/10/23.
//

import SwiftUI

struct ProductDetailsView: View {
    
    @StateObject private var viewModel : ProductDetailsViewModel
    @Environment(\.dismiss)var dismiss
    @State private var isAlertPresented = false
    @State private var isActive = false
    @State private var navigateToCart = false
    @State private var back = false
    var body: some View {
        ZStack {
            VStack{
                MainNavigationView(name: "Añadiendo al carrito".localized, action: {
                    dismiss()
                })
                VStack {
                    VStack (alignment: .leading) {
                        HStack {
                            Text(viewModel.productDetalis?.commericalName ?? "")
                                .foregroundStyle(Color.sloganColor)
                                .font(.excon(15, .bold))
                            Spacer()
                            HStack {
                                //Image("cup")
                                HStack {
                                    Text("SCA")
                                    Text("\(viewModel.productDetalis?.sca ?? "0")".roundToPlaces(1))
                                }
                                .font(.excon(13))
                            }
                        }
                        HStack(spacing: 2){
                            HStack(spacing: 2) {
                              //  Text("roastedBy".localized)
                                Text(viewModel.productDetalis?.providerName ?? "")
                            }
                            .font(.excon(13, .medium))
//                            Text("/")
//                            Text("Espena")
//                                .font(.excon(10))
                        }
                       // Text(viewModel.productDetalis?.description ?? "")
                    }
                    VStack (alignment: .leading) {
                       // Text("TuCompra")
//                            .padding()
//                            .foregroundStyle(Color.sloganColor)
//                            .font(.excon(15, .bold))
                        
                        ForEach ($viewModel.items.sorted { (first, second) -> Bool in
                            let firstWeight =  first.weight.wrappedValue
                            let secondWeight = second.weight.wrappedValue
                            return firstWeight > secondWeight
                        },id:\.id){ presentations in
                            
                            PresentationItem(presentations: presentations)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                        }
                    }
                    .cornerRadius(30)
                    .background {
                        Color(hex:"#FFF7F2")
                            .cornerRadius(30)
                    }
                    
                }
                .padding()
                .background {
                    Color(hex: "#FFEEE4")
                        .cornerRadius(30)
                }
                Spacer()
                
                Button {
                    viewModel.createCart()
                } label: {
                    HStack(spacing: 10){
                        Image(systemName: "cart")
                        
                        Text("Confirmar añadir al carrito")
                        Text("\($viewModel.price.wrappedValue)".roundToPlaces(2))
                    }
                    .font(.excon(15,.bold))
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background{
                        
                        RoundedRectangle(cornerRadius: 30)
                            .fill(viewModel.isEnableToContinuePayment() ? Color.buttonColor: .gray)
                    }
                    .disabled(!viewModel.isEnableToContinuePayment())
                }
            }
                if viewModel.isCartCreated {
                    
                    CustomPopAskingQuestion(createNewAddress: $navigateToCart, cancel: $viewModel.dismiss, question: "Quieres pagar ahora o volver a la tienda?", firstChoice: "Realizar pedido", secondChoice: "Continuar comprando")
                }
            }
        .padding(.horizontal)
        .navigationBarBackButtonHidden()
        .onAppear(perform: {
            viewModel.loadProductDetails()
        })
        .fullScreenCover(isPresented: $navigateToCart, content: {
            LazyView(GeneralCartView())
        })
        .onReceive(viewModel.$items, perform: { _ in
            viewModel.getPrice()
        })
        .onReceive(viewModel.$isCartCreated, perform: { value in
            if value {
                isAlertPresented.toggle()
            }
        })
        .onReceive(viewModel.$dismiss, perform: { value in
            guard value == true else { return }
            dismiss()
            
        })
     
        .onReceive(viewModel.$onError, perform: { error in
            if error?.title == "Unauthenticated." {
                setLoginRoot()
            }
        })
    }
    init(viewModel: ProductDetailsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
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

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView(
            viewModel: ProductDetailsViewModel(productId: "", productDetails: .init(id: 1, providerId: 1, commericalName: "rovle", providerName: "rovle", roaster: "test", description: "test", sca: "12", presentation: [.sample], region: "", origin: "", farm: "", altitude: "", coffeeShops: [.sample]), items: [.sample]))
    }
}

struct Cart : Codable {
    
    var mobile_id : String
    var provider_id : Int
    var presentations : [ItemPresentations]
    
}

struct ItemPresentations : Identifiable , Codable {
    var units : Int
    var id : Int
}

struct callbackCart :Codable {
    var status : Int
    var message : String
}
// decode and encode json from object
/*struct Person : Codable {
 let name: String
 let age: Int
 }
 
 do{
 let person = Person(name: "John Doe", age: 30)
 
 let encoder = JSONEncoder()
 let jsonD = try encoder.encode(person)
 print(jsonD)
 
 let jsonData = Data(bytes: jsonD)
 
 let utf8Text = String(data: jsonData, encoding: .utf8)
 
 let decoder = JSONDecoder()
 
 let p = try decoder.decode(Person.self, from: jsonData)
 
 print(utf8Text)
 
 }catch{
 print("")
 }
 */

