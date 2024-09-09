//
//  YourOldOrders.swift
//  Rovle
//
//  Created by Eslam Ghazy on 12/9/23.
//

import SwiftUI

struct YourOldOrders: View {
    private var order: OrderModel
    @Binding private var onTapDetails: OrderModel?
    @Binding private var onTapRating: OrderModel?
    
    var body: some View {
        if order.statusOfDescription != .none {
            ZStack (alignment: .topLeading){
                Text(order.statusOfDescription.title)
                    .font(.excon(16))
                    .underline(true)
                    .padding(8)
                    .background(content: {
                        order.statusOfDescription.color.opacity(0.5)
                            .cornerRadius(20)
                    })
                    .foregroundColor(.white)
                
                VStack{
                    Spacer()
                    VStack (spacing: 16){
                        HStack{
                            VStack(alignment: .leading) {
                                Text(order.productName)
                                    .foregroundStyle(Color.sloganColor)
                                    .font(.excon(16,.bold))
                                    .padding(.top, 16)
                            }
                            Spacer()
                            Button(action: {
                                onTapRating = order
                            }, label: {
                                Image("star")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(16)
                                    .background(content: {
                                        Color.firstBackgroundColor
                                    })
                            })
                           
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Text(order.createdAt.toDate("dd/MM/yyyy HH:mm:ss", to: "EE dd MMM yyyy").capitalized)
                                .foregroundStyle(Color.gray)
                                .font(.excon(12))
                                
                            Spacer()
                            Button(action: {
                                onTapDetails = order
                            }, label: {
                                HStack {
                                    Text("Emitir factura")
                                    Image("invoiceIcon")
                                }
                                .fixedSize()
                                .foregroundStyle(.white)
                                .padding(8)
                                .background {
                                    Color.sloganColor
                                        .cornerRadius(30)
                                }
                            })
                        }
                        .padding([.horizontal, .bottom])
                        .background(content: {
                            Color.firstBackgroundColor
                                .cornerRadius(20)
                        })
                        //            HStack {
                        //                Spacer()
                        //                Text(order.createdAt.toDate("dd/MM/YYYY HH:mm:ss", to: "EE MMM yyyy"))
                        //                    .foregroundStyle(Color.sloganColor)
                        //                    .font(.excon(12))
                        //            }
                        //            .padding(.bottom, 8)
                        //            .padding(.horizontal)
                    }
                   
                }
                
            }
            .background(content: {
                Color.firstBackgroundColor
                    .cornerRadius(20)
            })
            .padding()
        } else {
            VStack{
                
                VStack (spacing: 16){
                    HStack{
                        VStack(alignment: .leading, spacing: 16) {
                            Text(order.productName)
                                .foregroundStyle(Color.sloganColor)
                                .font(.excon(14,.bold))
                            
                            Text(order.createdAt.toDate("dd/MM/yyyy HH:mm:ss", to: "EE dd MMM yyyy").capitalized)
                                .foregroundStyle(Color.gray)
                                .font(.excon(12))
                        }
                        Spacer()
                        VStack(alignment: .trailing){
                            Image("star")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 8)
                                .onTapGesture {
                                    onTapRating = order 
                                }
                            Button(action: {
                                onTapDetails = order
                            }, label: {
                                HStack {
                                    Text("Emitir factura")
                                    Image("invoiceIcon")
                                }
                                .fixedSize()
                                .foregroundStyle(.white)
                                .padding(8)
                                .background {
                                    Color.sloganColor
                                        .cornerRadius(30)
                                }
                            })
                        }
                            //.foregroundStyle(Color.buttonColor)
                    }
                   
                    .padding()
                    .background(content: {
                        Color.firstBackgroundColor
                            .cornerRadius(20)
                    })
                }
              
            }
            .background(content: {
                Color.firstBackgroundColor
                    .cornerRadius(20)
            })
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
            
    }
    
    init(
        order: OrderModel,
        onTapDetails: Binding<OrderModel?>,
        onTapRating: Binding<OrderModel?>
    ) {
        self.order = order
        self._onTapDetails = onTapDetails
        self._onTapRating = onTapRating
    }
}

struct YourOldOrders_Previews: PreviewProvider {
    static var previews: some View {
        YourOldOrders(
            order: .init(
                id: UUID(),
                orderId: 1,
                createdAt: "12/12/2024 12:12:12",
                total: 12,
                productName: "hello",
                productId: "12",
                ratedBefore: "11",
                provider: "finca",
                products: [.init(id: 1, name: "Test", description: "testS", presentation: [.init(modelCart: .init(id: 1, cartItemID: 1, presentationID: 1, units: 2, weight: "2", price: "12", productID: 12, providerID: 12, createdAt: "12/12/2024 12:12:12", updatedAt: "12/12/2024 12:12:12", priceAfterDiscount: "12"))!])],
                taxses: "12",
                statusOfDescription: .delivered,
                status: "",
                shipping: "12",
                voucherType: .percentage,
                voucherAmount: "12"
            ),
            onTapDetails: .constant(.init(id: UUID(), orderId: 1, createdAt: "12/12/2024 12:12:12", total: 1, productName: "", productId: "", ratedBefore: "", provider: "", products: [], taxses: "", statusOfDescription: .delivered,
                                          status: "",shipping: "", voucherType: .percentage, voucherAmount: "")),
            onTapRating: .constant(.init(id: UUID(), orderId: 1, createdAt: "", total: 1, productName: "", productId: "", ratedBefore: "", provider: "", products: [], taxses: "", statusOfDescription: .delivered, status: "", shipping: "", voucherType: .percentage, voucherAmount: ""))
        )
    }
}
