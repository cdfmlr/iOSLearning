//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by c on 2021/1/18.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import KingfisherSwiftUI
import SwiftUI

struct PokemonInfoRow: View {
    @EnvironmentObject var store: Store

    /// View Model
    let model: PokemonViewModel
    /// 展开按钮
    // @State var expanded: Bool = false
    let expanded: Bool

//    @State var isSFViewActive = false

    var body: some View {
        VStack {
            // 图片、名字
            HStack {
                // Image("Pokemon-\(model.id)")
                KFImage(model.iconImageURL)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4)

                Spacer()

                VStack(alignment: .trailing) {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)

                    Text(model.nameEN)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 12)

            Spacer()

            // 按钮
            HStack(spacing: expanded ? 20 : -30) {
                Spacer()
                Button(action: {
                    print("fav")
                }) {
                    Image(systemName: "star")
                        .modifier(ToolButtonModifier())
                }
                Button(action: {
                    let target = !self.store.appState.pokemonList.dynamic.panelPresented
                    self.store.dispatch(
                        .togglePanelPresenting(presenting: target)
                    )
                }) {
                    Image(systemName: "chart.bar")
                        .modifier(ToolButtonModifier())
                }
//                Button(action: {
//                    print("web")
//                }) {
//                    Image(systemName: "info.circle")
//                        .modifier(ToolButtonModifier())
//                }
                NavigationLink(
                    destination: SafariView(url: model.detailPageURL) {
                        self.store.dispatch(.closeSafariView)
                    }
                    .navigationBarTitle(
                        Text(model.name),
                        displayMode: .inline
                    ),
                    isActive: expanded ?
                        $store.appState.pokemonList.isSFViewActive : .constant(false),
                    label: {
                        Image(systemName: "info.circle")
                            .modifier(ToolButtonModifier())
                    }
                )
            }
            .padding(.bottom, 12)
            .opacity(expanded ? 1.0 : 0.0)
            .frame(maxHeight: expanded ? .infinity : 0)
        }
        .frame(height: expanded ? 120 : 80)
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            ZStack {
                // woc，这边框丑爆了好吧。不要了，不要了。
                // RoundedRectangle(cornerRadius: 20)
                //    .stroke(model.color, style: StrokeStyle(lineWidth: 4))
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.white, model.color]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    ))
            }
        ) /* .padding(.horizontal) */
        .animation(.spring(
            response: 0.55,
            dampingFraction: 0.525,
            blendDuration: 0
        ))
//        .onTapGesture {
//            // withAnimation {
//            //     self.expanded.toggle()
//            // }
//            self.expanded.toggle()
//        }
    }
}

// fav, panel, web 按钮的修饰
struct ToolButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

struct PokemonInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PokemonInfoRow(model: .sample(id: 1), expanded: false)
            PokemonInfoRow(model: .sample(id: 21), expanded: true)
            PokemonInfoRow(model: .sample(id: 25), expanded: false)
        }.environmentObject(Store())
    }
}
