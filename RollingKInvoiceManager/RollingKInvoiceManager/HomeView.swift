//
//  HomeView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    private let columns = ["RK Number", "Gross", "Pickup Date", "Delivery Date", "Net"]
    
    var body: some View {
        VStack(spacing: 0) {
            // header row
            InvoiceHeaderView(columns: columns, invoices: viewModel.invoices)
            
            // list of invoices
            ScrollView {
                LazyVStack(spacing: 1) {
                    ForEach(viewModel.invoices) { invoice in
                        InvoiceRowView(invoice: invoice)
                            .background(Color(.systemBackground))
                            .onTapGesture {
                                // open invoice detail view
                            }
                    }
                }
            }
            
            Divider()
            
            // bottom buttons and totals
            BottomBarView(viewModel: viewModel)
                .padding()
        }
        .onAppear {
            viewModel.loadInvoices()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let invoices = [
            Invoice.sample(),
            {
                var s = Invoice.sample()
                s.rkNumber = "RK999-D"
                s.gross = 1_000_000
                s.net = 999_000
                return s
            }()
        ]
        HomeView()
            .previewDevice("iPad Air (5th generation)")
    }
}
