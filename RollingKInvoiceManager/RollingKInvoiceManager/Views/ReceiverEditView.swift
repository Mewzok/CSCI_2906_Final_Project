//
//  ReceiverEditView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/25/25.
//

import SwiftUI

struct ReceiverEditView: View {
    @State private var receiver: Receiver
    let onSave: (Receiver) -> Void
    @Environment(\.dismiss) private var dismiss
    
    init(receiver: Receiver, onSave: @escaping (Receiver) -> Void) {
        self._receiver = State(initialValue: receiver)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            Form {
                ReceiverForm(receiver: $receiver)
            }
            .navigationTitle("Edit Receiver")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        receiver.companyName = receiver.companyName.trimmingCharacters(in: .whitespacesAndNewlines)
                        onSave(receiver)
                        dismiss()
                    }
                    .disabled(receiver.companyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
