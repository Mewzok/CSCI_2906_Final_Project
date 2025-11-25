//
//  ReceiverForm.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/25/25.
//

import SwiftUI

struct ReceiverForm: View {
    @Binding var receiver: Receiver
    
    init(receiver: Binding<Receiver>) {
        self._receiver = receiver
        
        // initialize state from binding's current value
        let r = receiver.wrappedValue
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // receiver companyName
            HStack {
                Text("Company Name")
                Spacer()
                TextField("Company Name", text: $receiver.companyName)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 180)
            }
            // receiver address
            HStack {
                Text("Address")
                Spacer()
                TextField("Address", text: Binding(
                    get: { receiver.address ?? "" },
                    set: { receiver.address = $0.isEmpty ? nil : $0 }
                ))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 180)
            }
            // receiver phoneNumber
            HStack {
                Text("Phone Number")
                Spacer()
                TextField("Phone Number", text: Binding(
                    get: { receiver.phoneNumber ?? ""},
                    set: { receiver.phoneNumber = $0.isEmpty ? nil : $0 }
                ))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 180)
            }
            .padding(.top, 8)
        }
    }
}
