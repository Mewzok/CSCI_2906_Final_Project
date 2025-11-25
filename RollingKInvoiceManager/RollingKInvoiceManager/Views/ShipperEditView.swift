//
//  ShipperEditView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/25/25.
//

import SwiftUI

struct ShipperEditView: View {
    @State private var shipper: Shipper
    let onSave: (Shipper) -> Void
    @Environment(\.dismiss) private var dismiss
    
    init(shipper: Shipper, onSave: @escaping (Shipper) -> Void) {
        self._shipper = State(initialValue: shipper)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            Form {
                ShipperForm(shipper: $shipper)
            }
            .navigationTitle("Edit Shipper")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        shipper.companyName = shipper.companyName.trimmingCharacters(in: .whitespacesAndNewlines)
                        onSave(shipper)
                        dismiss()
                    }
                    .disabled(shipper.companyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
