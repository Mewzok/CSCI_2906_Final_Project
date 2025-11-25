//
//  ShipperForm.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/25/25.
//

import SwiftUI

struct ShipperForm: View {
    @Binding var shipper: Shipper

    init(shipper: Binding<Shipper>) {
        self._shipper = shipper
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // shipper companyName
            HStack {
                Text("Company Name")
                Spacer()
                TextField("Company Name", text: $shipper.companyName)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 180)
            }
            // shipper address
            HStack {
                Text("Address")
                Spacer()
                TextField("Address", text: Binding(
                    get: { shipper.address ?? "" },
                    set: { shipper.address = $0.isEmpty ? nil : $0 }
                ))
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 180)
            }
            // shipper phoneNumber
            HStack {
                Text("Phone Number")
                Spacer()
                TextField("Phone Number", text: Binding(
                    get: { shipper.phoneNumber ?? ""},
                    set: { shipper.phoneNumber = $0.isEmpty ? nil : $0 }
                ))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 180)
            }
        }
        .padding(.top, 8)
    }
}
