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
    @State private var invoiceToEdit: Invoice? = nil
    @State private var isLoading = true
    
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
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(invoices) { invoice in
                                InvoiceRowView(invoice: invoice)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        invoiceToEdit = invoice
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
                        invoiceToEdit = nil
                        showingInvoiceForm = true
                    }
                }
            }
            .sheet(isPresented: $showingInvoiceForm) {
                InvoiceFormView(invoice: invoiceToEdit ?? Invoice.sample(), onSave: { newInvoice in
                    if invoiceToEdit == nil {
                        InvoiceService.shared.addInvoice(newInvoice) { _ in
                            fetchInvoices()
                        }
                    } else {
                        InvoiceService.shared.updateInvoice(newInvoice) { _ in
                            fetchInvoices()
                        }
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
