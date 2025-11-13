//
//  InvoiceFormView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/13/25.
//

import SwiftUI

struct InvoiceFormView: View {
    @State var invoice: Invoice
    var onSave: (Invoice) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section("Invoice Info") {
                TextField("RK#", text: $invoice.rkNumber)
                // TextField("Other #", text: $invoice.otherNumber)
                TextField("Broker Company Name", text: $invoice.broker.companyName)
            }
        }
    }
}

#Preview {
    //InvoiceFormView()
}
