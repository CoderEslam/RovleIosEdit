//
//  ProductCartItem.swift
//  Rovle
//
//  Created by Eslam Ghazy on 30/8/23.
//

import SwiftUI

struct ProductCartItem: View {
  
   @Binding var cartItem: CartItemsModel
    private var roaster: String
    private var deleteItem: (_: (Presentations)->())
    private var increaseQuantity: (_: (Presentations)->())
    private var decreaseQuantity: (_: (Presentations)->())
    @State private var showDetails: Bool = false
    var body: some View {
        
        VStack(alignment: .leading,  spacing: 8) {
            VStack (alignment: .leading, spacing: 8){
                VStack(alignment: .leading, spacing:8){
                    HStack(spacing: 2){
                        HStack(spacing: 2) {
                            Text(roaster)
                        }
                        .font(.excon(13))
                        .foregroundStyle(Color.sloganColor)
                        Spacer()
                    }
                    .padding(.top,4)
                    .onTapGesture {
                        withAnimation {
                            showDetails.toggle()
                        }
                    }
                    
                    Text(cartItem.product?.name ?? "")
                        .foregroundStyle(Color.sloganColor)
                        .font(.excon(13))
                }
//                .background {
//                    Color.backgroundComponents
//                      // .cornerRadius(20)
//                      
//                }
                VStack{
                    HStack {
                        Text(cartItem.product?.name ?? "")
                            .foregroundStyle(Color.sloganColor)
                            .font(.excon(15, .bold))
                        Spacer()
                        
                        Image(systemName: showDetails ? "chevron.down" : "chevron.right")
                        
                        
                        
                    }
                    .padding(.horizontal,8)
                    .padding(.vertical, 2)
                    
                    if showDetails {
                        withAnimation {
                            VStack (alignment: .leading){
                                ForEach($cartItem.presentation, id: \.self) { presentation in
                                    PresentationCartItemView(
                                        presentation: presentation,
                                        roaster: roaster,
                                        deleteItem: deleteItem,
                                        updateItem: increaseQuantity,
                                        decreaseQuantity: decreaseQuantity
                                    )
                                }
                                
                            }
                            //.padding(16)
                            .padding(.vertical,4)
                            .padding(.horizontal, 8)
                            .background {
                                Color.firstBackgroundColor
                                    .cornerRadius(20)
                            }
                        }
                    }
                }
                .background {
                    Color.firstBackgroundColor
                       .cornerRadius(20)
                }
            }.onTapGesture {
                withAnimation {
                    showDetails.toggle()
                }
            }
           
        }
        .padding([.horizontal, .bottom], 8)
        .background {
            Color.backgroundComponents
                .cornerRadius(15)
        }
       
    }
    init(cartItem: Binding<CartItemsModel>, roaster: String, deleteItem: (_: (Presentations) -> Void), updateItem: (_: (Presentations) -> Void), decreaseQuantity: (_: (Presentations) -> Void)) {
        self._cartItem = cartItem
        self.roaster = roaster
        self.deleteItem = deleteItem
        self.increaseQuantity = updateItem
        self.decreaseQuantity = decreaseQuantity
    }
   
}

//struct ProductCartItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCartItem(cartItem: .constant( Presentations(id: 9, price: 9, weight: "", units: "", quantity: 9, providerId: 0, priceAfterDiscount: 0)),deleteItem: {_ in }, updateItem: {_ in }, decreaseQuantity: {_ in})
//    }
//}
