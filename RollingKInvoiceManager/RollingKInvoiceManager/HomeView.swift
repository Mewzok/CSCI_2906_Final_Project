//
//  HomeView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var invoices: [Invoice] = []
    @State private var isLoading = true
    
    let columns = [
        GridItem(.flexible(), alignment: .leading),  // RK#
        GridItem(.flexible(), alignment: .leading),  // PO#
        GridItem(.flexible(), alignment: .leading),  // Pickup
        GridItem(.flexible(), alignment: .leading)   // Delivery
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            // header row
            LazyVGrid(columns: columns, spacing: 16) {
                Text("RK#").bold()
                Text("PO#").bold()
                Text("Pickup").bold()
                Text("Delivery").bold()
            }
            .padding(.horizontal)
            
            Divider()
            
            // invoice rows
            if isLoading {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if invoices.isEmpty {
                Text("No invoices found").padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(invoices) { invoice in
                            Text(invoice.rkNumber)
                            Text(invoice.broker.poNumber ?? "-")
                            Text(dateString(invoice.pickupDate))
                            Text(dateString(invoice.deliveryDate))
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            loadInvoices()
        }
    }
    
    // date format helper
    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func loadInvoices() {
        isLoading = true
        InvoiceService.shared.fetchInvoices { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetched):
                    self.invoices = fetched
                case .failure(let error):
                    print("Error fetching invoices: \(error)")
                    self.invoices = []
                }
                self.isLoading = false
            }
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
