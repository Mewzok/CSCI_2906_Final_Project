//
//  BrokerForm.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/25/25.
//

import SwiftUI

struct BrokerForm: View {
    @Binding var broker: Broker
    
    init(broker: Binding<Broker>) {
        self._broker = broker
        
        // initialize state from binding's current value
        let b = broker.wrappedValue
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // broker companyName
            HStack {
                Text("Company Name")
                Spacer()
                TextField("Company Name", text: $broker.companyName)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 180)
            }
            // broker address
            HStack {
                Text("Address")
                Spacer()
                TextField("Address", text: Binding(
                    get: { broker.address ?? "" },
                    set: { broker.address = $0.isEmpty ? nil : $0 }
                ))
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 180)
            }
            // broker phoneNumber
            HStack {
                Text("Phone Number")
                Spacer()
                TextField("Phone", text: Binding(
                    get: { broker.phoneNumber ?? "" },
                    set: { broker.phoneNumber = $0.isEmpty ? nil : $0 }
                ))
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 180)
            }
            // broker email
            HStack {
                Text("Broker Email")
                Spacer()
                TextField("Email", text: Binding(
                    get: { broker.email ?? "" },
                    set: { broker.email = $0.isEmpty ? nil : $0 }
                ))
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 180)
            }
        }
        .padding(.vertical, 6)
    }
}
