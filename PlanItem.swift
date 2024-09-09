//
//  PlansItem.swift
//  Rovle
//
//  Created by Eslam Ghazy on 6/9/23.
//

import SwiftUI

struct PlanItem: View {
    
    @State var isOpen :Bool = true
    private var planSize: SizeModel
    @State private var plan: PlanDetailsModel
    @State private var showDetails: Bool = true
    @State var isAbleToNavigate :Bool = false
    private var subscriptionId: Int?
    var body: some View {
        VStack (alignment: .leading ){
                VStack(alignment: .leading ) {
                    HStack {
                        Text(plan.name)
                            .font(.excon(16))
                            .foregroundColor(.sloganColor)
                            
                        Spacer()
                        Image(systemName: showDetails ? "chevron.down" : "chevron.up")
                    }
                    
                    .onTapGesture {
                        withAnimation {
                            showDetails.toggle()
                        }
                    }
                    if showDetails {
                        if plan.description.count > 200 {
                            ScrollView {
                                Text(plan.description)
                                    .padding(.top,0)
                                    .padding(.bottom,8)
                                    .font(.excon(12))
                            }
                        } else {
                            Text(plan.description)
                                .padding(.vertical, 8)
                                .font(.excon(12))
                        }
                        HStack {
                            Text("Empieza desde")
                                .font(.excon(12))
                            Spacer()
                            HStack {
                                Text(planSize.weight + "g")
                                Text("=")
                                Text("\(planSize.price)" + "€")
                            }
                        }
                        NavigationLink (isActive: $isAbleToNavigate) {
                            LazyView(
                                PlanInformationView(
                                    viewModel: PlanInformationViewModel(
                                        subscriptionId: subscriptionId,
                                        planDetails:  plan
                                    )
                                )
                            )
                        } label: {
                            
                            HStack{
                                Text("Suscribirse")
                                    .padding()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)

                                    .background(content: {
                                        if planSize.isSubscribed {
                                            Color.gray
                                                .cornerRadius(20)
                                        } else {
                                            Color.sloganColor
                                                .cornerRadius(20)
                                        }
                                    })
                                    
                                    .onTapGesture {
                                        setSelectedPlan(sizeId: planSize.id)
                                    }
                               
                            }
                                
                        }
                        
                        .disabled(planSize.isSubscribed)
                    }
                }
                .padding()
                .background(content: {
                    Color.white
                        .cornerRadius(15)
                })
            
        }
        .foregroundStyle(Color.sloganColor)
        .font(.excon(16))
      .padding(.horizontal, 4)
      .padding(.bottom, 8)
    }
   
    init(subscriptionId: Int? = nil ,isOpen: Bool, plan: PlanDetailsModel, planSize: SizeModel) {
        self.subscriptionId = subscriptionId
        self.isOpen = isOpen
        self.plan = plan
        self.planSize = planSize
    }
    
    func setSelectedPlan(sizeId: Int) {
        var selectedPlan = plan
        guard var sizeSelected = selectedPlan.size.first(where: {$0.id == sizeId}) else { return }
        sizeSelected.selected = true
        selectedPlan.size.removeAll(where: {$0.id == sizeSelected.id})
        selectedPlan.size.append(sizeSelected)
        self.plan = selectedPlan
        isAbleToNavigate = true
   }
}

//struct PlansItem_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanItem(isOpen: false, planSize: .constant(.sample))
//    }
//}
