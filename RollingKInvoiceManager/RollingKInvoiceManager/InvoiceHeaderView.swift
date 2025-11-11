//
//  InvoiceHeaderView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import SwiftUI

struct InvoiceHeaderView: View {
    let columns: [String]
    let invoices: [Invoice]
    
    var body: some View {
        GeometryReader { geometry in
            let columnWidths = calculateColumnWidths(in: geometry.size.width)
            
            HStack(spacing: 0) {
                ForEach(Array(columns.enumerated()), id: \.offset) { index, title in
                        Text(title)
                        .font(.headline)
                        .frame(width: columnWidths[index], alignment: .center)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.2))
                        .border(Color.gray, width: 0.5)
                }
            }
        }
        .frame(height: 40)
    }
    
    private func calculateColumnWidths(in totalWidth: CGFloat) -> [CGFloat] {
        // evenly spaced for now, dynamically calculate later
        let count = CGFloat(columns.count)
        return Array(repeating: totalWidth / count, count: columns.count)
    }
}

struct InvoiceHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceHeaderView(columns: ["RK Number", "Gross", "Pickup Date", "Delivery Date", "Net"], invoices: [Invoice.sample()])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
