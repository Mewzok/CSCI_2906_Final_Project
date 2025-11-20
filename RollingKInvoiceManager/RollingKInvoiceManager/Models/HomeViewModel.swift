//
//  HomeViewModel.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
class HomeViewModel: ObservableObject {
    @Published var invoices: [Invoice] = []
    @Published var dispatcherTotal: Double = 0
    @Published var employeeTotal: Double = 0
    @Published var netTotal: Double = 0
    
    // preview/testing
    init(previewInvoices: [Invoice]? = nil) {
        if let previewInvoices = previewInvoices {
            self.invoices = previewInvoices
            recalculateTotals()
        }
    }
    
    func loadInvoices(fetchLimit: Int? = 100) {
        InvoiceService.shared.fetchInvoices(limit: fetchLimit) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let invoices):
                    self.invoices = invoices
                    self.recalculateTotals()
                case .failure(let error):
                    print("Error loading invoices:", error)
                }
            }
        }
    }
    
    func recalculateTotals() {
        dispatcherTotal = invoices.reduce(0) {
            $0 + ($1.net * (($1.dispatchFee ?? 0) / 100))
        }
        employeeTotal = invoices.reduce(0) {
            $0 + ($1.net * 0.1)
        }
        netTotal = invoices.reduce(0) {
            $0 + $1.net
        }
    }
}
