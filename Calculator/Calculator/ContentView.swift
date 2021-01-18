//
//  ContentView.swift
//  Calculator
//
//  Created by c on 2021/1/11.
//  Copyright © 2021 CDFMLR. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let scale: CGFloat = UIScreen.main.bounds.width / 414 // 414 是设计宽度

//    @State private var brain: CalculatorBrain = .left("0")
//    @ObservedObject var model = CalculatorModel()
    @EnvironmentObject var model: CalculatorModel

    @State private var editingHistory = false
    @State private var showingResult = false

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            HStack {
                if model.history.count > 0 {
                    Button("\(model.historyDetial)") {
                        self.editingHistory.toggle()
                    }.sheet(isPresented: self.$editingHistory) {
                        VStack {
                            HStack {
                                Button(action: {
                                    // 撤销操作
                                    self.model.slidingIndex = Float(
                                        self.model.totalHistoryCount)
                                    // 关闭 sheet
                                    self.editingHistory.toggle()
                                }){
                                    Text("Cancel").bold()
                                }
                                Spacer()
                                Button("Done"){
                                    // 关闭 sheet
                                    self.editingHistory.toggle()
                                }
                            }.padding()
                            
                            Spacer()
                            HistoryView(model: self.model)
                            Spacer()
                        }
                        // 下面👇这些没用：
//                        .navigationBarTitle("navigation")
//                        .navigationBarItems(leading: Button("Cancel") {
//                            // 撤销操作
//                            self.model.slidingIndex = Float(
//                                self.model.totalHistoryCount)
//                            // 关闭 sheet
//                            self.editingHistory.toggle()
//                        })
//                        .navigationBarHidden(false)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 24)

            Text(model.brain.output)
                .font(.system(size: 76))
                .foregroundColor(Color.gray)
                .padding(.trailing, 24)
//                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(minWidth: 0, maxWidth: .infinity,
                       alignment: .trailing)
                .onTapGesture {
                    if self.model.historyDetial.hasSuffix("=") {
                        self.showingResult.toggle()
                    }
                }.alert(isPresented: self.$showingResult) {
                    let result = "\(model.historyDetial)\(model.brain.output)"
                    return Alert(title: Text("Result"),
                                 message: Text(result),
                                 primaryButton: .default(Text("Copy")) {
                                     print("copy to pasteboard: \(result)")
                                     UIPasteboard.general.string = result
                                 },
                                 secondaryButton: .cancel(Text("OK")))
                }

            CalculatorButtonPad()
                .padding(.bottom)
        }
        .scaleEffect(scale)
//        .background(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        Group {
//            ContentView()
//                .environment(\.colorScheme, .light)
//
//            ContentView()
//                .environment(\.colorScheme, .dark)
//        }
//            .previewDevice("iPhone SE")
        ContentView()
            .environmentObject(CalculatorModel())
    }
}
