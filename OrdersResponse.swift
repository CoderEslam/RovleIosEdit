//
//  OrdersResponse.swift
//  Rovle
//
//  Created by Sharaf on 12/8/23.
//

import Foundation
import SwiftUI

struct OrdersResponse: Codable {
    
    let currentPage: Int?
    let data: [OrderResponse]?
    let lastPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case lastPage = "last_page"
    }
}


// MARK: - Datum

struct OrderResponse: Codable {
    let orderID: Int?
    let createdAt, updatedAt: String?
    let total: Double?
    let productID: Int?
    let productName: String?
    let voucherType: String?
    let voucherAmount: String?
    let statusDescription: String?
    let status: String
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case total
        case productID = "product_id"
        case productName = "product_name"
        case voucherType = "voucher_type"
        case voucherAmount = "voucher_amount"
        case statusDescription = "status_description"
        case status
    }
}

struct OrderModel: Identifiable {
    var id: UUID
    let orderId: Int
    let createdAt: String
    let total: Double
    let productName: String
    let productId: String
    let ratedBefore: String?
    let provider: String
    let products: [ProductModel]
    let taxses: String
    var statusOfDescription: StatusOfOrder
    let status: String
    let shipping: String
    let voucherType: VoucherType?
    let voucherAmount: String
    var voucherValue: String {
        if let voucherType, voucherType == .percentage {
            return voucherAmount + "%"
        } else {
            return voucherAmount + "€"
        }
    }
}

extension OrderModel :Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.orderId == rhs.orderId 
    }
}
enum StatusOfOrder: String {
    case pending = "Pendiente de envio"
    case inProgress
    case delivered
    case none
}

extension StatusOfOrder {
    var title: String {
        switch self {
        case .delivered:
            return ""
        case .inProgress:
            return ""
        case .pending:
            return "Pendiente de envio"
        case .none:
            return ""
        }
    }
    var color: Color {
        switch self {
        case .delivered:
            return Color.green
        case .inProgress:
            return Color.buttonColor
        case .pending:
            return Color.red
        case .none:
            return Color.clear
        }
    }
}
extension OrderModel {
    init?(model: OrderResponse) {
        guard let orderId = model.orderID else { return nil }
        self.init(
            id: UUID(),
            orderId: orderId,
            createdAt: model.createdAt ?? "",
            total: model.total?.rounded(toPlaces: 2) ?? 0,
            productName: model.productName ?? "",
            productId: "\(model.productID ?? 0)" ,
            ratedBefore: "1",
            provider: "",
            products: [],
            taxses: "",
            statusOfDescription:StatusOfOrder(rawValue: model.statusDescription ?? "") ?? .none,
            status: model.status,
            shipping: "",
            voucherType: VoucherType(rawValue: model.voucherType ?? ""),
            voucherAmount: model.voucherAmount ?? ""
        )
    }
    
//    init?(model: OrderDetails) {
//         let orderId = model.id
//        self.init(id: UUID(), orderId: orderId, createdAt: model.createdAt , total: model.total , productName: model.name , productId: model.productId , ratedBefore: "1", provider: "", products: [],taxses: "",status:"",shipping: "")
//    }
    
    init?(model: ListOrderResponse) {
        guard let orderId = model.id else { return nil }
        guard let products = model.products?.compactMap({ProductModel(model: $0)}) else { return nil }
        self.init(
            id: UUID(),
            orderId: orderId,
            createdAt: model.createdAt ?? "",
            total: model.total?.rounded(toPlaces: 2) ?? 0,
            productName: model.products?.first?.productName ?? "",
            productId: "",
            ratedBefore: model.provider?.rate?.rate ?? "",
            provider: model.provider?.commercialName ?? "",
            products: products,
            taxses: "\(model.taxes?.rounded(toPlaces: 2) ?? 0)",
            statusOfDescription: StatusOfOrder(rawValue: model.statusDescription ?? "") ?? .none, status: model.status ?? "",
            shipping: "\(model.shipping?.rounded(toPlaces: 2) ?? 0)",
            voucherType: VoucherType(rawValue: model.voucherType ?? ""),
            voucherAmount: model.voucherAmount?.rate ?? ""
        )
    }
}

//extension OrderModel {
//    static var sample: OrderModel {
//        .init(id: UUID(), orderId: 0, createdAt: "2023-10-10 12:23:12", total: 0, productName: "Codde", productId: 1, ratedBefore: 1)
//    }
//}
