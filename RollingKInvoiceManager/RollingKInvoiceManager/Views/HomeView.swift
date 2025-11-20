//
//  HomeView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//  Main home screen

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var showingInvoiceForm = false
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var currentInvoice: Invoice = Invoice(id: nil, rkNumber: "", otherNumber: "", broker: Broker(companyName: ""), shipper: Shipper(companyName: ""), receiver: Receiver(companyName: ""), gross: 0.0, net: 0.0)
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    InvoiceHeaderView()
                        .padding(.horizontal)
                    
                    Divider()
                    if let error = errorMessage {
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 56))
                                .foregroundColor(.red)
                            Text(error)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button("Retry") {
                                fetchInvoices()
                            }
                            .padding(.top)
                            .buttonStyle(.borderedProminent)
                            .disabled(isLoading)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.invoices.isEmpty {
                        Text("No invoices found")
                            .padding()
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(viewModel.invoices) { invoice in
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
                    InvoiceFormView(invoice: $currentInvoice, brokers: $viewModel.brokers, shippers: $viewModel.shippers, receivers: $viewModel.receivers, onSave: { savedInvoice in
                        if savedInvoice.id == nil {
                            // new invoice, add new
                            InvoiceService.shared.addInvoice(savedInvoice) { _ in fetchInvoices() }
                        } else {
                            // edited invoice, update
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
                
                // loading overlay, appears over everything else
                if isLoading {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(1.8)
                        Text("Loading invoices...")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.top, 8)
                    }
                    .padding(24)
                    .background(RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground).opacity(0.7))
                        .shadow(radius: 8)
                    )
                }
            }
            .onAppear {
                viewModel.loadAllLogistics()
            }
        }
    }
    
    func fetchInvoices() {
        isLoading = true
        errorMessage = nil
        InvoiceService.shared.fetchInvoices { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetched):
                    viewModel.invoices = fetched
                case .failure(let error):
                    print("Error fetching invoices \(error)")
                    viewModel.invoices = []
                    errorMessage = "Could not load invoices. Please check your internet and try again."
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
