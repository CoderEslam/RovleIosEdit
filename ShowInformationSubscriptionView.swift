//
//  ShowInformationSubscriptionView.swift
//  Rovle
//
//  Created by Eslam Ghazy on 7/9/23.
//

import SwiftUI

struct ShowInformationSubscriptionView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: ShowInformationSubscriptionViewModel
    @ObservedObject var imageLoader:ImageLoader = ImageLoader(urlString: "https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg")
    @State var image:UIImage = UIImage()
    

    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                VStack{
                    MainNavigationView(name: "planName".localized) {
                        dismiss()
                    }
                   
                    VStack{
                        
                        Text("Receipt ID:".localized + "\(viewModel.selectedPlanInfo.planId) ")
                            .foregroundColor(Color.sloganColor)
                            .padding(.top,24)
                        
                        InvoiceRowsView(title: "plan".localized, value: viewModel.selectedPlanInfo.name, color: .init(hex: "#FFF7F2"))
                        InvoiceRowsView(title: "price".localized, value: "\(viewModel.selectedPlanInfo.price)", color: .init(hex: "#FFF7F2"))
                        InvoiceRowsView(title: "provider".localized, value: viewModel.planDetailsModel.provider.name, color: .init(hex: "#FFF7F2"))
                        ForEach(viewModel.planDetailsModel.product, id:\.id) { product in
                            InvoiceRowsView(title: "product".localized, value: product.name, color: .init(hex: "#FFF7F2"))
                        }
                        InvoiceRowsView(title: "period".localized, value: "\(viewModel.selectedPlanInfo.periodicity) month", color: .init(hex: "#FFF7F2"))
                        // delete impustos
//                        InvoiceRowsView(title: "taxes".localized, value: " ", color: .init(hex: "#FFF7F2"))
                        
                        InvoiceRowsView(title: "shipping".localized, value: "\(viewModel.selectedPlanInfo.shipping) €", color: .init(hex: "#FFF7F2"))
                        InvoiceRowsView(title: "total".localized, value: "\(viewModel.selectedPlanInfo.total)" + "€", color: .init(hex: "#FFF7F2"))
                        
                        
                    }
                    .padding()
                    VStack{
                        NavigationLink{
                            PaymentView(planDetailsModel: viewModel.planDetailsModel, planInformation: viewModel.selectedPlanInfo)
                        } label: {
                            Text("Confirm Informations".localized).frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.sloganColor)
                                .foregroundColor(Color.white)
                                .mask(RoundedRectangle(cornerRadius: 10))
                                .padding(.top,20)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        
    }
    
    init( viewModel: ShowInformationSubscriptionViewModel) {
        self.viewModel = viewModel
    }
}

//struct ShowInformationSubscribtion_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowInformationSubscriptionView(viewModel: ShowInformationSubscriptionViewModel(selectedPlanInfo: .init(selectedPlanInfo: .init(id: 1, selected: false, sizeId: 1, planId: 1, price: "", name: "", weight: "", status: .active), planId: "", sizeId: "", deliveryType: .home, zipCode: "", name: "", phone: "", email: "", lockerLocation: "", address: "", periodicity: 1)))
//    }
//}
