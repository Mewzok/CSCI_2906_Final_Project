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
        HStack(spacing: 0) {
            Text(invoice.rkNumber)
            Text(String(format: "$%.2f", invoice.gross))
            Text(invoice.pickupDate.formatted(date: .numeric, time: .omitted))
            Text(invoice.deliveryDate.formatted(date: .numeric, time: .omitted))
            Text(String(format: "$%.2f", invoice.net))
        }
        .frame(maxWidth: .infinity)
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .padding(.vertical, 6)
        .background(Color.white)
        .border(Color.gray.opacity(0.5))
    }
}

struct InvoiceRowView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceRowView(invoice: Invoice.sample())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
