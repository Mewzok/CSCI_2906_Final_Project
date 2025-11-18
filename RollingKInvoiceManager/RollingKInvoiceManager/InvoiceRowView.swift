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
        HStack {
            Text(invoice.rkNumber)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(invoice.broker.poNumber ?? "-")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(dateString(invoice.pickupDate))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(dateString(invoice.deliveryDate))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 6)
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
