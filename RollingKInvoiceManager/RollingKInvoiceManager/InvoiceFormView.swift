//
//  InvoiceFormView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/13/25.
//  Form to input/edit invoice fields

import SwiftUI

struct InvoiceFormView: View {
    // create local copy so edits are safe until used
    @State private var invoice: Invoice
    let onSave: (Invoice) -> Void
    let onDelete: ((String) -> Void)?
    @Environment(\.dismiss) private var dismiss
    
    // section visibility, create is expanded, edit is collapsed
    @State private var showInvoiceInfo: Bool
    @State private var showBroker: Bool
    @State private var showShipper: Bool
    @State private var showReceiver: Bool
    @State private var showFinances: Bool
    @State private var showDates: Bool
    
    // toggles for optional fees
    @State private var factorEnabled: Bool
    @State private var dispatchEnabled: Bool
    
    init(invoice: Invoice, onSave: @escaping (Invoice) -> Void, onDelete: ((String) -> Void)? = nil) {
        // local copy
        self._invoice = State(initialValue: invoice)
        self.onSave = onSave
        self.onDelete = onDelete
        
        // if invoice.id == nil, it's a new invoice, expand everything
        let isNew = (invoice.id == nil)
        self._showInvoiceInfo = State(initialValue: isNew)
        self._showBroker = State(initialValue: isNew)
        self._showShipper = State(initialValue: isNew)
        self._showReceiver = State(initialValue: isNew)
        self._showFinances = State(initialValue: isNew)
        self._showDates = State(initialValue: isNew)
        
        // toggles. non-zero is automatically enabled
        self._factorEnabled = State(initialValue: invoice.factorFee > 0)
        self._dispatchEnabled = State(initialValue: (invoice.dispatchFee ?? 0) > 0)
    }
    
    // compute totals
    private var computedNet: Double {
        var result = invoice.gross
        
        // subtract lumper cost if present
        if let lumper = invoice.lumperCost {
            result -= lumper
        }
        
        // factor fee is a percentage applied to the gross
        if factorEnabled {
            result -= result * (invoice.factorFee / 100.0)
        }
        
        // dispatch fee percentage applied tot he post-factor result
        if dispatchEnabled, let df = invoice.dispatchFee {
            result -= result * (df / 100.0)
        }
        
        // employee cost, flat
        if let emp = invoice.employeeCost {
            result -= emp
        }
        
        return result
    }
    
    private var computedDispatchCost: Double {
        // dispatch cost shown as percentage of the post-factor net
        if dispatchEnabled, let df = invoice.dispatchFee {
            return computedNet * (df / (100.0 - (factorEnabled ? invoice.factorFee : 0.0)))
        } else {
            return invoice.dispatchCost ?? 0.0
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // scrollview for content, fixed totals/footer
                ScrollView {
                    VStack(spacing: 12) {
                        // invoice info
                        DisclosureGroup(isExpanded: $showInvoiceInfo) {
                            VStack(alignment: .leading, spacing: 12) {
                                TextField("RK#", text: $invoice.rkNumber)
                                // optional string for otherNumber
                                TextField("Other #", text: Binding(
                                    get: { invoice.otherNumber ?? ""},
                                    set: { invoice.otherNumber = $0.isEmpty ? nil : $0 }
                                ))
                                // broker company name quick edit
                                TextField("Broker Company Name", text: $invoice.broker.companyName)
                            }
                            .padding(.top, 8)
                        } label: {
                            sectionLabel("Invoice")
                        }
                        .padding(.horizontal)
                        
                        // broker section
                        DisclosureGroup(isExpanded: $showBroker) {
                            VStack(alignment: .leading, spacing: 12) {
                                TextField("Company", text: $invoice.broker.companyName)
                                TextField("Address", text: Binding(
                                    get: { invoice.broker.address ?? "" },
                                    set: { invoice.broker.address = $0.isEmpty ? nil: $0 }
                                ))
                                // PO number optional
                                HStack {
                                    Text("PO")
                                        .foregroundColor(.secondary)
                                    var brokerPONumberBinding: Binding<Int> {
                                        Binding(
                                            get: { invoice.broker.poNumber ?? 0 },
                                            set: { invoice.broker.poNumber = $0 }
                                    )}
                                    NumericTextFieldInt(value: brokerPONumberBinding, placeholder: "PO#")
                                }
                                // phone and email
                                TextField("Phone", text: Binding(
                                    get: { invoice.broker.phoneNumber ?? "" },
                                    set: { invoice.broker.phoneNumber = $0.isEmpty ? nil : $0 }
                                ))
                                TextField("Email", text: Binding(
                                    get: { invoice.broker.email ?? "" },
                                    set: { invoice.broker.email = $0.isEmpty ? nil : $0 }
                                ))
                                // numeric temperature (fahrenheit)
                                HStack {
                                    NumericTextField(value: Binding(
                                        get: { invoice.broker.reeferTemperature ?? 0.0 },
                                        set: { invoice.broker.reeferTemperature = $0 }
                                    ), placeholder: "Reefer °F")
                                    Text("°F")
                                        .foregroundColor(.secondary)
                                }
                                TextField("Extra info", text: Binding(
                                    get: { invoice.broker.extraInfo ?? "" },
                                    set: { invoice.broker.extraInfo = $0.isEmpty ? nil : $0 }
                                ))
                            }
                            .padding(.top, 8)
                        } label: {
                            sectionLabel("Broker")
                        }
                        .padding(.horizontal)
                        
                        // shipper
                        DisclosureGroup(isExpanded: $showShipper) {
                            VStack(alignment: .leading, spacing: 12) {
                                TextField("Company", text: $invoice.shipper.companyName)
                                TextField("Address", text: Binding(
                                    get: { invoice.shipper.address ?? "" },
                                    set: { invoice.shipper.address = $0.isEmpty ? nil : $0 }
                                ))
                                TextField("Delivery Address", text: Binding(
                                    get: { invoice.shipper.deliveryAddress ?? "" },
                                    set: { invoice.shipper.deliveryAddress = $0.isEmpty ? nil : $0 }
                                ))
                                HStack {
                                    DatePicker("Pickup Date/Time", selection: Binding(
                                        get: { invoice.shipper.pickupDateTime ?? Date() },
                                        set: { invoice.shipper.pickupDateTime = $0 }
                                    ), displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                }
                                HStack {
                                    NumericTextField(value: Binding(
                                        get: { invoice.shipper.approximateWeight ?? 0.0 },
                                        set: { invoice.shipper.approximateWeight = $0 }
                                    ), placeholder: "Weight")
                                    Text("lbs").foregroundColor(.secondary)
                                }
                                NumericTextFieldInt(value: Binding(
                                    get: { invoice.shipper.confirmationNumber ?? 0 },
                                    set: { invoice.shipper.confirmationNumber = $0 }
                                ), placeholder: "Confirmation #")
                                TextField("Extra info", text: Binding(
                                    get: { invoice.shipper.extraInfo ?? "" },
                                    set: { invoice.shipper.extraInfo = $0.isEmpty ? nil : $0 }
                                ))
                            }
                            .padding(.top, 8)
                        } label: {
                            sectionLabel("Shipper")
                        }
                        .padding(.horizontal)
                        
                        // receiver
                        DisclosureGroup(isExpanded: $showReceiver) {
                            VStack(alignment: .leading, spacing: 12) {
                                TextField("Company", text: $invoice.receiver.companyName)
                                TextField("Address", text: Binding(
                                    get: { invoice.receiver.address ?? "" },
                                    set: { invoice.receiver.address = $0.isEmpty ? nil : $0 }
                                ))
                                TextField("Delivery Address", text: Binding(
                                    get: { invoice.receiver.deliveryAddress ?? "" },
                                    set: { invoice.receiver.deliveryAddress = $0.isEmpty ? nil : $0 }
                                ))
                                HStack {
                                    DatePicker("Pickup Date/Time", selection: Binding(
                                        get: { invoice.receiver.pickupDateTime ?? Date() },
                                        set: { invoice.receiver.pickupDateTime = $0 }
                                    ), displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                }
                                HStack {
                                    NumericTextField(value: Binding(
                                        get: { invoice.receiver.approximateWeight ?? 0.0 },
                                        set: { invoice.receiver.approximateWeight = $0 }
                                    ), placeholder: "Weight")
                                    Text("lbs").foregroundColor(.secondary)
                                }
                                NumericTextFieldInt(value: Binding(
                                    get: { invoice.receiver.pickupNumber ?? 0 },
                                    set: { invoice.receiver.pickupNumber = $0 }
                                ), placeholder: "Pickup #")
                                TextField("Extra info", text: Binding(
                                    get: { invoice.receiver.extraInfo ?? "" },
                                    set: { invoice.receiver.extraInfo = $0.isEmpty ? nil : $0 }
                                ))
                            }
                            .padding(.top, 8)
                        } label: {
                            sectionLabel("Receiver")
                        }
                        .padding(.horizontal)
                        
                        // finances
                        DisclosureGroup(isExpanded: $showFinances) {
                            VStack(alignment: .leading, spacing: 12) {
                                // Gross
                                HStack {
                                    Text("Gross")
                                    Spacer()
                                    TextField("Gross", value: $invoice.gross, format: .number)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                }
                                
                                // Lumper cost
                                HStack {
                                    Text("Lumper")
                                    Spacer()
                                    TextField("Lumper", value: Binding(
                                        get: { invoice.lumperCost ?? 0.0 },
                                        set: { invoice.lumperCost = $0 == 0 ? nil : $0 }
                                    ), format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                }
                                
                                // Factor fee toggle + percent
                                Toggle("Apply factor fee", isOn: $factorEnabled)
                                HStack {
                                    Text("Factor %")
                                    Spacer()
                                    TextField("%", value: $invoice.factorFee, format: .number)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                        .disabled(!factorEnabled)
                                }
                                
                                // Dispatch fee toggle + percent
                                Toggle("Apply dispatch fee", isOn: $dispatchEnabled)
                                HStack {
                                    Text("Dispatch %")
                                    Spacer()
                                    TextField("%", value: Binding(
                                        get: { invoice.dispatchFee ?? 5.0 },
                                        set: { invoice.dispatchFee = $0 }
                                    ), format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .disabled(!dispatchEnabled)
                                }
                                
                                // Employee cost
                                HStack {
                                    Text("Employee Cost")
                                    Spacer()
                                    TextField("Employee", value: Binding(
                                        get: { invoice.employeeCost ?? 0.0 },
                                        set: { invoice.employeeCost = $0 == 0 ? nil : $0 }
                                    ), format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                }
                                
                                // Live computed values
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Computed Dispatch Cost")
                                        Spacer()
                                        Text(computedDispatchCost, format: .currency(code: "USD"))
                                    }
                                    HStack {
                                        Text("Computed Net")
                                        Spacer()
                                        Text(computedNet, format: .currency(code: "USD"))
                                    }
                                }
                                .padding(.top, 8)
                            }
                            .padding(.top, 8)
                        } label: {
                            sectionLabel("Finances")
                        }
                        .padding(.horizontal)
                        
                        // dates
                        DisclosureGroup(isExpanded: $showDates) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    DatePicker("Pickup", selection: $invoice.pickupDate, displayedComponents: [.date, .hourAndMinute])
                                        .datePickerStyle(.compact)
                                }
                                HStack {
                                    DatePicker("Delivery", selection: $invoice.deliveryDate,    displayedComponents: [.date, .hourAndMinute])
                                        .datePickerStyle(.compact)
                                }
                                HStack {
                                    DatePicker("Factor Date", selection: Binding(
                                        get: { invoice.factorDate ?? Date() },
                                        set: { invoice.factorDate = $0 }
                                    ), displayedComponents: [.date])
                                    .datePickerStyle(.compact)
                                }
                                HStack {
                                    DatePicker("Factor Due", selection: Binding(
                                        get: { invoice.factorDue ?? Date() },
                                        set: { invoice.factorDue = $0 }
                                    ), displayedComponents: [.date])
                                    .datePickerStyle(.compact)
                                }
                            }
                            .padding(.top, 8)
                        } label: {
                            sectionLabel("Dates")
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 32)
                    }
                    .padding(.top, 12)
                } // end of scrollview
                
                // footer with dynamic totals and modifications
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Dispatch")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(computedDispatchCost, format: .currency(code: "USD"))
                                .font(.headline)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Net:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(computedNet, format: .currency(code: "USD"))
                                .font(.headline)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Button(role: .destructive) {
                            // delete if id exists
                            if let id = invoice.id {
                                onDelete?(id)
                                dismiss()
                            } else {
                                dismiss()
                            }
                        } label: {
                            Text(invoice.id == nil ? "Cancel" : "Delete Invoice")
                                .frame(maxWidth: .infinity)
                        }
                        
                        Button {
                            // store computed net back on main model before saving
                            var saved = invoice
                            saved.net = computedNet
                            saved.dispatchCost = computedDispatchCost
                            onSave(saved)
                            dismiss()
                        } label: {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
                .background(Color(.systemBackground).shadow(radius: 0.5))
            } // end of vstack
            .navigationTitle(invoice.id == nil ? "New Invoice" : "Edit Invoice")
        } // end of navigationview
    }
    
    // helper functions
    private func sectionLabel(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
        }
    }
}

// helper views
fileprivate struct NumericTextField: View {
    @Binding var value: Double
    var placeholder: String
    
    init(value: Binding<Double>, placeholder: String = "") {
        self._value = value
        self.placeholder = placeholder
    }
    
    @State private var text: String = ""
    
    var body: some View {
        TextField(placeholder, text: Binding(
            get: {
                if text.isEmpty {
                    if value == 0 {
                        return ""
                    }
                    return String(value)
                }
                return text
            },
            set: { new in
                text = new
                let cleaned = new.replacingOccurrences(of: ",", with: "")
                if let d = Double(cleaned) {
                    value = d
                } else if new.isEmpty {
                    value = 0
                }
            })
        )
        .keyboardType(.decimalPad)
        .multilineTextAlignment(.trailing)
        .onAppear {
            if value != 0 { text = String(value) }
        }
    }
}

// int variant
fileprivate struct NumericTextFieldInt: View {
    @Binding var value: Int
    var placeholder: String
    
    init(value: Binding<Int>, placeholder: String = "") {
        self._value = value
        self.placeholder = placeholder
    }
    
    @State private var text: String = ""
    
    var body: some View {
        TextField(placeholder, text: Binding(
            get: {
                if text.isEmpty {
                    return value == 0 ? "" : String(value)
                }
                return text
            },
            set: { new in
                text = new
                let cleaned = new.replacingOccurrences(of: ",", with: "")
                if let i = Int(cleaned) {
                    value = i
                } else if new.isEmpty {
                    value = 0
                }
            })
        )
        .keyboardType(.numberPad)
        .multilineTextAlignment(.trailing)
        .onAppear {
            if value != 0 { text = String(value)}
        }
    }
}

#Preview {
    //InvoiceFormView()
}
