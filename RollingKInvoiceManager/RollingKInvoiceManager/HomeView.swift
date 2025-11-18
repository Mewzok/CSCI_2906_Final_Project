//
//  HomeView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//  Main home screen

import SwiftUI

struct HomeView: View {
    @State private var invoices: [Invoice] = []
    @State private var showingInvoiceForm = false
    @State private var isLoading = true
    @State private var currentInvoice: Invoice = Invoice(id: nil, rkNumber: "", otherNumber: "", broker: Broker(companyName: ""), shipper: Shipper(companyName: ""), receiver: Receiver(companyName: ""), gross: 0.0, net: 0.0)
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                InvoiceHeaderView()
                    .padding(.horizontal)
                
                Divider()
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if invoices.isEmpty {
                    Text("No invoices found")
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(invoices) { invoice in
                                InvoiceRowView(invoice: invoice)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        currentInvoice = invoice
                                        showingInvoiceForm = true
                                    }
                                
                                Divider()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Invoices")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Invoice") {
                        // creating new invoice
                        currentInvoice = Invoice(id: nil, rkNumber: "", otherNumber: "", broker: Broker(companyName: ""), shipper: Shipper(companyName: ""), receiver: Receiver(companyName: ""), gross: 0.0, net: 0.0)
                        showingInvoiceForm = true
                    }
                }
            }
            .sheet(isPresented: $showingInvoiceForm) {
                InvoiceFormView(
                    invoice: currentInvoice,
                    onSave: { savedInvoice in
                    if savedInvoice.id == nil {
                        InvoiceService.shared.addInvoice(savedInvoice) { _ in fetchInvoices() }
                    } else {
                        InvoiceService.shared.updateInvoice(savedInvoice) { _ in fetchInvoices() }
                    }
                }, onDelete: { id in
                    InvoiceService.shared.deleteInvoice(id: id) { _ in
                        fetchInvoices()
                    }
                })
            }
            .onAppear {
                fetchInvoices()
            }
        }
    }
    
    func fetchInvoices() {
        isLoading = true
        InvoiceService.shared.fetchInvoices { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetched):
                    invoices = fetched
                case .failure(let error):
                    print("Error fetching invoices \(error)")
                    invoices = []
                }
                isLoading = false
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPad Air (5th generation)")
    }
}
