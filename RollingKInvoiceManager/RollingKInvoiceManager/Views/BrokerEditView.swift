//
//  BrokerEditView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/25/25.
//

import SwiftUI

struct BrokerEditView: View {
    @State private var broker: Broker
    let onSave: (Broker) -> Void
    @Environment(\.dismiss) private var dismiss
    
    init(broker: Broker, onSave: @escaping (Broker) -> Void) {
        self._broker = State(initialValue: broker)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            Form {
                BrokerForm(broker: $broker)
            }
            .navigationTitle("Edit Broker")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        broker.companyName = broker.companyName.trimmingCharacters(in: .whitespacesAndNewlines)
                        onSave(broker)
                        dismiss()
                    }
                    .disabled(broker.companyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
