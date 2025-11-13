//
//  InvoiceRowView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import SwiftUI

struct InvoiceRowView: View {
    let invoice: Invoice
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .leading)
        ]) {
            Text(invoice.rkNumber)
            Text(invoice.broker.poNumber ?? "-")
            Text(dateString(invoice.pickupDate))
            Text(dateString(invoice.deliveryDate))
        }
        .padding(.vertical, 4)
    }
    
    private func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .short
        return f.string(from: date)
    }
}

struct InvoiceRowView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceRowView(invoice: Invoice.sample())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
