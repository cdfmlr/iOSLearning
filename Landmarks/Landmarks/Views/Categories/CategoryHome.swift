//
//  CategoryHome.swift
//  Landmarks
//
//  Created by c on 2021/1/7.
//  Copyright © 2021 CDFMLR. All rights reserved.
//

import SwiftUI

struct CategoryHome: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    
    var body: some View {
        NavigationView {
            List {
                PageView(pages: modelData.features.map { FeatureCard(landmark: $0) })
                .aspectRatio(3 / 2, contentMode: .fit)
                .listRowInsets(EdgeInsets())
                
                ForEach (modelData.categories.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, items: self.modelData.categories[key]!)
                }
                .listRowInsets(EdgeInsets())
            }
            .navigationBarTitle("Featured")
            .navigationBarItems(trailing: Button(action: { self.showingProfile.toggle() }) {
                Image(systemName: "person.crop.circle")
                    .imageScale(.large)
                    .accessibility(label: Text("User Profile"))
                    .padding()
            })
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(self.modelData)
            }
        }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
        .environmentObject(ModelData())
    }
}
