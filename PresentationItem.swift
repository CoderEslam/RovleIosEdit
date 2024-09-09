//
//  PresentationItem.swift
//  Rovle
//
//  Created by Eslam Ghazy on 4/10/23.
//

import SwiftUI

struct PresentationItem: View {
    
    var presentations  : Binding<Presentations>
    var body: some View {
        HStack{
            
            Text("\(presentations.wrappedValue.weight)")
                .font(.excon(12, .bold))

                .padding(.horizontal)
                .fixedSize()
            
            
            if presentations.wrappedValue.priceAfterDiscount == nil {
                Text("\(presentations.wrappedValue.price)".roundToPlaces(2) + " €")
                    .font(.excon(12, .bold))
                    .fixedSize()
            } else {
                HStack {
                    Text("\(presentations.wrappedValue.price)".roundToPlaces(2))
                        .strikethrough()
                        .fixedSize()
                    Text("\(presentations.wrappedValue.priceAfterDiscount ?? 0) ".roundToPlaces(2))
                        .fixedSize()
                }
                .font(.excon(12, .bold))
            }
            
            Spacer()
            
            HStack(){
                VStack{
                    Image(systemName: "minus")
                        .padding(8)
                        .foregroundColor(.buttonColor)
                }
                .background(content: {
                    Color.white
                })
                .onTapGesture {
                    withAnimation{
                        if presentations.wrappedValue.quantity > 0 {
                            presentations.wrappedValue.quantity =  presentations.wrappedValue.quantity - 1
                            if presentations.wrappedValue.quantity == 0 {
                                presentations.wrappedValue.selected = false
                            }
                        }
                    }
                }
                
                Text("\(presentations.wrappedValue.quantity)")
                    .fixedSize()
                
                Image(systemName: "plus")
                    .padding(8)
                    .foregroundColor(.buttonColor)
                    .onTapGesture {
                        withAnimation{
                            if presentations.wrappedValue.offerUnit == nil || presentations.wrappedValue.offerUnit == 0 {
                                presentations.wrappedValue.quantity =  presentations.wrappedValue.quantity + 1
                                presentations.wrappedValue.selected = true
                            } else {
                                if presentations.wrappedValue.quantity + 1 <= presentations.wrappedValue.offerUnit! {
                                    presentations.wrappedValue.quantity =  presentations.wrappedValue.quantity + 1
                                    presentations.wrappedValue.selected = true
                                }
                            }
                        }
                    }
            }
        }
        .foregroundColor(.gray)
        .padding()
        .font(.excon(12, .bold))
        .background {
            Color(hex: "#FFFFFF")
                .cornerRadius(30)
        }
        .padding(4)
    }
}

//struct PresentationItem_Previews: PreviewProvider {
//    static var previews: some View {
//        PresentationItem(presentations: .constant( Presentations(id: 1, price: "0", weight: "", units: "", quantity: 1, providerId: "1", priceAfterDiscount: 0, cartId: 0)))
//    }
//}

extension String {
    func roundToPlaces(_ place: Int) -> Self {
        return String(format: self, "%.\(place)f")
    }
}
