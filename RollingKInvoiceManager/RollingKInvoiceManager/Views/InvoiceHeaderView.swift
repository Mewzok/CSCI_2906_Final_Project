//
//  InvoiceHeaderView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import SwiftUI

struct InvoiceHeaderView: View {
    let columns = ["RK#", "PO#", "Pickup", "Delivery"]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .leading), count: 4)) {
            ForEach(columns, id: \.self) { title in
                Text(title).bold()
            }
        }
    }
}

struct InvoiceHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceHeaderView()
            .padding()
    }
}
