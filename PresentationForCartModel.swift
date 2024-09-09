//
//  PresentationForCartModel.swift
//  Rovle
//
//  Created by Sharaf on 11/25/23.
//

import Foundation
// MARK: - Presentation
struct PresentationModel: Codable {
    let id, cartItemID, presentationID, units: Int?
    let weight, price: String?
    let productID, providerID: Int?
    let createdAt, updatedAt: String?
    let priceAfterDiscount: String?
    
    enum CodingKeys: String, CodingKey {
        case id, weight,  units
        case price = "price_per_unit"
        case productID = "product_id"
        case providerID = "provider_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cartItemID = "cart_item_id"
        case presentationID = "presentation_id"
        case priceAfterDiscount = "price_after_discount"
    }
}


struct Presentations: Codable, RequestParamtersEncodable,Hashable , Identifiable{
    var toDictionary: [String : Any]? {
        if let priceAfterDiscount = priceAfterDiscount {
            [
                "id": id,
                "units": quantity,
                "provider_id": providerId
            ]
        } else {
            [
                "id": id,
                "units": quantity,
                "provider_id": providerId
            ]
        }
    }
    
    let id: Int
    var price: String
    var weight: String
    var units: Int
    var quantity: Int
    var selected: Bool = false
    var providerId: String
    let priceAfterDiscount: Double?
    var offerUnit: Int? = 0
    let cartId: Int?
    var totalPrice: Double {
        (priceAfterDiscount)?.rounded(toPlaces: 2) ?? 0
        //(( (Double(price)! * (Double(units)!)))).rounded(toPlaces: 1)
    }
}

extension Presentations {
    static var sample: Presentations{ .init(id: 1, price: "12", weight: "20", units: 1, quantity: 2, providerId: "12", priceAfterDiscount: 12, cartId: 1)}
    init?(model: PresentationsModel) {
        guard let id = model.id , let weight = model.weight else { return nil}
        let units = model.units != 0 ? model.units : 0
        self.init(
            id: id,
            price: "\(model.price ?? 0)".roundToPlaces(2) ,
            weight: "\(weight) g",
            units: model.units ?? 1,
            quantity: 0,
            providerId:"\( model.providerID ?? 0)",
            priceAfterDiscount: nil,
            cartId: nil

        )
    }
    
    init?(modelCart: PresentationModel) {
        guard let id = modelCart.presentationID , let weight = modelCart.weight, let price = modelCart.price  else { return nil}
        self.init(
            id: id,
            price: price.roundToPlaces(2) + "€",
            weight: "\(weight) g",
            units: modelCart.units ?? 0,
            quantity: 1,
            providerId: "\(modelCart.providerID ?? 0)",
            priceAfterDiscount: Double(modelCart.priceAfterDiscount ?? "0"),
            cartId: nil

        )
    }
    
    init?(model: PresentationForOfferModel) {
         let id = model.id
        let weight = model.weight
        
        self.init(
            id: id,
            price: "\(model.price) €",
            weight: weight,
            units: Int(model.units) ?? 0,
            quantity:   Int(model.units) ??  0,
            selected: false,
            providerId:"\(model.providerId)",
            priceAfterDiscount: model.priceAfterDiscount,
            offerUnit: model.offerUnits, cartId: nil
        )
    }
    
    init?(model: PresentationForListCart) {
         let id = model.id
        self.init(
            id: id,
            price: "\(model.Price) €",
            weight: "\(model.weight) g",
            units: 1,
            quantity: model.quantity,
            selected: model.selected,
            providerId: "\(model.providerId)",
            priceAfterDiscount: model.priceAfterDiscount,
            cartId: nil
          
        )
    }
    
    init?(model: ListCartPresentationResponse) {
        guard let id = model.presentationID else { return nil }
        var total: Double? = nil
        if let totalPrice = model.discount {
            total = model.priceAfterDiscount
        } else {
            total = model.total ?? 0
        }
        self.init(
            id: id,
            price: "\(model.priceAfterDiscount  ?? model.pricePerUnit ?? 0)",
            weight: "\(model.weight ?? "0")g",
            units: Int(model.units?.rate ?? "0") ?? 0 ,
            quantity: Int(model.units?.rate ?? "0") ?? 0,
            providerId: "0",
            priceAfterDiscount: model.priceAfterDiscount ?? 0,
            cartId: model.cartItemID
        )
    }
    
    init?(model: ItemResponse) {
        guard let id = model.presentationID else { return nil }
        self.init(
            id: id,
            price: "\(model.pricePerUnit ?? 0)",
            weight: "\(model.presentation?.weight ?? 0)",
            units: Int(model.units ?? 0),
            quantity: Int(model.units ?? 0),
            providerId: "",
            priceAfterDiscount: model.priceAfterDiscount ?? 0,
            cartId: nil
        )
    }
    
    init?(model: ItemForOrderResponse) {
        guard let id = model.presentationID else { return nil }
        self.init(
            id: id,
            price: "\(model.presentation?.price ?? 0)",
            weight: "\(model.presentation?.weight ?? 0) g",
            units: model.units ?? 0,
            quantity:  model.units ?? 0,
            providerId: "",
            priceAfterDiscount: model.priceAfterDiscount ?? 0,
            cartId: nil
        )
    }
    
}
