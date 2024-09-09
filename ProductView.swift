//
//  productView.swift
//  Rovle
//
//  Created by Sharaf on 1/31/24.
//

import SwiftUI

struct ProductView: View {
    
   private var product: AllProduct
   @Binding private var verfichaActionProductId: Int?
   @Binding private var addToCartActionProductId: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(product.commericalName)
                    .font(.excon(15, .medium))
                    .foregroundColor(.titleColor)
                Spacer()
                //Text(String(describing: product.presentations?[0].weight) ?? "")
            }
            VStack (alignment: .leading, spacing: 1) {
                HStack(spacing: 2){
                    HStack(spacing: 2) {
                        //Text("Tostado por")
                        Text(product.providerName)
                    }
                    .font(.excon(13, .medium))
                    //Text("/")
//                    Text("Espena")
//                        .font(.excon(10))
                }
                
                HStack {
                  //  Image("cup")
                    HStack {
                        Text("SCA:")
                        Text("\(product.scaScore)".roundToPlaces(1))
                    }
                    .font(.excon(13))
                    Spacer()
                }
            }
            .foregroundColor(.titleColor)
            
            HStack {
                HStack(alignment: .center, spacing: 12) {
                    Button {
                       verfichaActionProductId = product.id
                    } label: {
                        Text("Ver ficha")
                            .font(.excon(16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.sloganColor)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
               // .background(Color(red: 0.25, green: 0.15, blue: 0.13))
                .cornerRadius(20)
                
                Spacer()
                
                Button(action: {
                    addToCartActionProductId = product.id
                }, label: {
                    HStack(alignment: .center, spacing: 12) {
                        Image("cart")
                        Text("Añadir al carrito")
                        .font(Font.custom("Excon", size: 13))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.24, green: 0.73, blue: 0.94))
                    .cornerRadius(20)
                })
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.backgroundComponents)
        }
        .padding(.horizontal)
    }
    
    init(
        product: AllProduct,
        verfichaActionProductId:Binding<Int?>,
        addToCartActionProductId: Binding<Int?>) {
        self.product = product
        self._verfichaActionProductId = verfichaActionProductId
        self._addToCartActionProductId = addToCartActionProductId
    }
}

#Preview {
    ProductView(product: .sampleData, verfichaActionProductId: .constant(nil), addToCartActionProductId: .constant(nil))
}
