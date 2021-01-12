//
//  ContentView.swift
//  Landmarks
//
//  Created by c on 2020/5/12.
//  Copyright © 2020 CDFMLR. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .featured
    
    enum Tab {
        case featured
        case list
    }
    
    var body: some View {
        TabView(selection: $selection) {
            CategoryHome()
                .tag(Tab.featured)
                .tabItem {
                    // Xcode 12: Label("Featured", systemImage: "star")
                    Image(systemName: "star")
                        .imageScale(.medium)
                    Text("Featured")
            }
            
            LandmarkList()
                .tag(Tab.list)
                .tabItem {
                    // Xcode 12: Label("List", systemImage: "list.bullet")
                    Image(systemName: "list.bullet")
                        .imageScale(.medium)
                    Text("List")
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
