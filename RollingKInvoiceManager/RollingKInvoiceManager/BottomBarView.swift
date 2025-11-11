//
//  BottomBarView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import SwiftUI

struct BottomBarView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Dispatcher Total: \(format(viewModel.dispatcherTotal))")
                Spacer()
                Text("Employee Total: \(format(viewModel.employeeTotal))")
                Spacer()
                Text("Net Total: \(format(viewModel.netTotal))")
            }
            .font(.footnote)
            
            HStack {
                Button("Create New Invoice") {
                    // open invoice creator
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                Button("Edit Logistics") {
                    // open logistics editor
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 8)
        }
    }
    
    private func format(_ value: Double) -> String {
        "$" + String(format: "%.2f", value)
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = HomeViewModel(previewInvoices: [Invoice.sample(), Invoice.sample()])
        BottomBarView(viewModel: vm)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
