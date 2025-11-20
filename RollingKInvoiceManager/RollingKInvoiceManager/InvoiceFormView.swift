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
        self._factorEnabled = State(initialValue: (invoice.factorFee ?? 0) > 0)
        self._dispatchEnabled = State(initialValue: (invoice.dispatchFee ?? 0) > 0)
    }
    
    // invoice section
    private var invoiceSection: some View {
        DisclosureGroup(isExpanded: $showInvoiceInfo) {
            VStack(alignment: .leading, spacing: 12) {
                // rkNumber
                HStack {
                    Text("RK#")
                    Spacer()
                    TextField("RK#", text: $invoice.rkNumber)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // otherNumber
                HStack {
                    Text("Other#")
                    Spacer()
                    TextField("Other #", text: optionalStringBinding(\.otherNumber))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
            }
            .padding(.top, 8)
        } label: {
            sectionLabel("Invoice")
        }
        .padding(.horizontal)
    }
    
    // broker section
    private var brokerSection: some View {
        DisclosureGroup(isExpanded: $showBroker) {
            VStack(alignment: .leading, spacing: 12) {
                // broker companyName
                HStack {
                    Text("Company Name")
                    Spacer()
                    TextField("Company Name", text: $invoice.broker.companyName)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // broker address
                HStack {
                    Text("Address")
                    Spacer()
                    TextField("Address", text: optionalStringBinding(\.broker.address))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                HStack {
                    //poNumber
                    Text("PO#")
                    Spacer()
                    NumericTextFieldInt(value: optionalIntBinding(\.broker.poNumber), placeholder: "PO#")
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // broker phoneNumber
                HStack {
                    Text("Phone Number")
                    Spacer()
                    TextField("Phone", text: optionalStringBinding(\.broker.phoneNumber))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // broker email
                HStack {
                    Text("Broker Email")
                    Spacer()
                    TextField("Email", text: optionalStringBinding(\.broker.email))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // broker minReeferTemperature
                HStack {
                    Text("Broker Min Temperature")
                    Spacer()
                    NumericTextField(value: optionalDoubleBinding(\.broker.minReeferTemperature), placeholder: "Reefer min")
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 90)
                    Text("°F").foregroundColor(.secondary)
                }
                // broker maxReeferTemperature
                HStack {
                    Text("Broker Max Temperature")
                    Spacer()
                    NumericTextField(value: optionalDoubleBinding(\.broker.maxReeferTemperature), placeholder: "Reefer max")
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 90)
                    Text("°F").foregroundColor(.secondary)
                }
                // broker extraInfo
                VStack(alignment: .leading, spacing: 6) {
                    Text("Extra Info")
                    TextEditor(text: optionalStringBinding(\.broker.extraInfo))
                        .frame(height: 100)
                        .padding(6)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
            }
            .padding(.top, 8)
        } label: {
            sectionLabel("Broker")
        }
        .padding(.horizontal)
    }
    
    // shipper section
    private var shipperSection: some View {
        // shipper
        DisclosureGroup(isExpanded: $showShipper) {
            VStack(alignment: .leading, spacing: 12) {
                // shipper companyName
                HStack {
                    Text("Company Name")
                    Spacer()
                    TextField("Company Name", text: $invoice.shipper.companyName)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // shipper address
                HStack {
                    Text("Address")
                    Spacer()
                    TextField("Address", text: optionalStringBinding(\.shipper.address))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // shipper deliveryAddress
                HStack {
                    Text("Delivery Address")
                    Spacer()
                    TextField("Delivery Address", text: optionalStringBinding(\.shipper.deliveryAddress))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // shipper pickupDateTime
                HStack {
                    Text("Pickup Date/Time")
                    Spacer()
                    DatePicker("", selection: optionalDateBinding(\.shipper.pickupDateTime), displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .frame(height: 30)
                }
                // shipper approximateWeight
                HStack {
                    Text("Approximate Weight")
                    Spacer()
                    NumericTextField(value: optionalDoubleBinding(\.shipper.approximateWeight), placeholder: "Weight")
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 90)
                    Text("lbs").foregroundColor(.secondary)
                }
                //shipper confirmationNumber
                HStack {
                    Text("Confirmation #")
                    Spacer()
                    NumericTextFieldInt(value: optionalIntBinding(\.shipper.confirmationNumber), placeholder: "Confirmation #")
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // shipper extraInfo
                VStack(alignment: .leading, spacing: 6) {
                    Text("Extra Info")
                    TextEditor(text: optionalStringBinding(\.shipper.extraInfo))
                        .frame(height: 100)
                        .padding(6)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
            }
            .padding(.top, 8)
        } label: {
            sectionLabel("Shipper")
        }
        .padding(.horizontal)
    }
    
    // receiver section
    private var receiverSection: some View {
        // receiver
        DisclosureGroup(isExpanded: $showReceiver) {
            VStack(alignment: .leading, spacing: 12) {
                // receiver companyName
                HStack {
                    Text("Company Name")
                    Spacer()
                    TextField("Company Name", text: $invoice.receiver.companyName)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // receiver address
                HStack {
                    Text("Address")
                    Spacer()
                    TextField("Address", text: optionalStringBinding(\.receiver.address))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // receiver deliveryAddress
                HStack {
                    Text("Delivery Address")
                    Spacer()
                    TextField("Delivery Address", text: optionalStringBinding(\.receiver.deliveryAddress))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // receiver pickupDateTime
                HStack {
                    Text("Pickup Date/Time")
                    Spacer()
                    DatePicker("", selection: optionalDateBinding(\.receiver.pickupDateTime), displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .frame(height: 30)
                }
                // receiver approximateWeight
                HStack {
                    Text("Approximate Weight")
                    Spacer()
                    NumericTextField(value: optionalDoubleBinding(\.receiver.approximateWeight), placeholder: "Weight")
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 90)
                    Text("lbs").foregroundColor(.secondary)
                }
                // receiver pickupNumber
                HStack {
                    Text("Pickup #")
                    Spacer()
                    NumericTextFieldInt(value: optionalIntBinding(\.receiver.pickupNumber), placeholder: "Pickup #")
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // receiver extraInfo
                VStack(alignment: .leading, spacing: 6) {
                    Text("Extra Info")
                    TextEditor(text: optionalStringBinding(\.receiver.extraInfo))
                        .frame(height: 100)
                        .padding(6)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
            }
            .padding(.top, 8)
        } label: {
            sectionLabel("Receiver")
        }
        .padding(.horizontal)
    }
    
    // finance section
    private var financeSection: some View {
        // finances
        DisclosureGroup(isExpanded: $showFinances) {
            VStack(alignment: .leading, spacing: 12) {
                // gross
                HStack {
                    Text("Gross")
                    Spacer()
                    HStack {
                        Text("$")
                        TextField("Gross", value: $invoice.gross, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 90)
                    }
                }
                // lumperCost
                HStack {
                    Text("Lumper")
                    Spacer()
                    HStack {
                        Text("$")
                        TextField("Lumper", value: optionalDoubleBinding(\.lumperCost), format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 90)
                    }
                }
                // employee cost
                HStack {
                    Text("Employee Cost")
                    Spacer()
                    HStack {
                        Text("$")
                        TextField("Employee Cost", value: optionalDoubleBinding(\.employeeCost), format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 90)
                    }
                }
                // factor fee toggle and percent
                HStack {
                    Text("Factor Fee")
                    Spacer()
                    HStack(spacing: 4) {
                        TextField("Factor Fee", value: Binding(
                            get: { invoice.factorFee ?? 2.5 },
                            set: { invoice.factorFee = $0 }
                        ), format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 90)
                            .disabled(!factorEnabled)
                            .opacity(factorEnabled ? 1.0 : 0.5)
                            .foregroundColor(factorEnabled ? .primary : .secondary)
                        Text("%")
                        Toggle("", isOn: $factorEnabled)
                            .labelsHidden()
                            .onChange(of: factorEnabled) { newValue in
                                if newValue {
                                    // toggle turned on
                                    if invoice.factorFee == nil {
                                        invoice.factorFee = 2.5 // default
                                    }
                                } else {
                                    // toggle turned off
                                    invoice.factorFee = nil
                                }
                            }
                    }
                }
                
                // dispatch fee toggle and percent
                HStack {
                    Text("Dispatch Fee")
                    Spacer()
                    HStack(spacing: 4) {
                        TextField("Dispatch Fee", value: Binding(
                            get: { invoice.dispatchFee ?? 5.0 },
                            set: { invoice.dispatchFee = $0 }
                        ), format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 90)
                        .disabled(!dispatchEnabled)
                        .opacity(dispatchEnabled ? 1.0 : 0.5)
                        .foregroundColor(factorEnabled ? .primary : .secondary)
                        Text("%")
                        Toggle("", isOn: $dispatchEnabled)
                            .labelsHidden()
                            .onChange(of: dispatchEnabled) { newValue in
                                if newValue {
                                    // toggle turned on
                                    if invoice.dispatchFee == nil {
                                        invoice.dispatchFee = 5.0 // default
                                    }
                                } else {
                                    // toggle turned off
                                    invoice.dispatchFee = nil
                                }
                            }
                    }
                }
                .padding(.top, 8)
            }
            .padding(.top, 8)
        } label: {
            sectionLabel("Finances")
        }
        .padding(.horizontal)
    }
    
    // date section
    private var dateSection: some View {
        VStack {
            DisclosureGroup(isExpanded: $showDates) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        DatePicker("Pickup", selection: optionalDateBinding(\.pickupDate), displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                    }
                    HStack {
                        DatePicker("Delivery", selection: optionalDateBinding(\.deliveryDate),
                                   displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                    }
                    HStack {
                        DatePicker("Factor Date", selection: optionalDateBinding(\.factorDate), displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                    }
                    HStack {
                        DatePicker("Factor Due", selection: optionalDateBinding(\.factorDue), displayedComponents: [.date, .hourAndMinute])
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
    }
    
    // compute totals
    private var computedDispatchCost: Double {
        if dispatchEnabled, let df = invoice.dispatchFee {
            return invoice.gross * (df / 100.0)
        } else {
            return 0.0
        }
    }
    
    private var computedFactorCost: Double {
        if factorEnabled, let ff = invoice.factorFee {
            return invoice.gross * (ff / 100.0)
        } else {
            return 0.0
        }
    }
    
    private var computedNet: Double {
        var result = invoice.gross
        
        // subtract lumper cost if present
        if let lumper = invoice.lumperCost {
            result -= lumper
        }
        
        // factor fee is a percentage applied to the gross
        if factorEnabled {
            result -= computedFactorCost
        }
        
        // dispatch fee percentage applied tot he post-factor result
        if dispatchEnabled {
            result -= computedDispatchCost
        }
        
        // employee cost, flat
        if let emp = invoice.employeeCost {
            result -= emp
        }
        
        return result
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // scrollview for content, fixed totals/footer
                ScrollView {
                    VStack(spacing: 12) {
                        invoiceSection
                        brokerSection
                        shipperSection
                        receiverSection
                        dateSection
                        financeSection
                    } // end of scrollview
                    
                    // footer with dynamic totals and modifications
                    VStack(spacing: 8) {
                        HStack {
                            // display lumper pay, not necessary now but might enable in future
                            /*
                            VStack(alignment: .leading) {
                                Text("Lumper")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(optionalDoubleBinding(\.lumperCost).wrappedValue ?? 0, format: .currency(code: "USD"))
                                    .font(.headline)
                            }
                            
                            Spacer() */
                            // display factor pay
                            VStack(alignment: .leading) {
                                Text("Factor")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(computedFactorCost, format: .currency(code: "USD"))
                                    .font(.headline)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Dispatch")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(computedDispatchCost, format: .currency(code: "USD"))
                                    .font(.headline)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Employee")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(optionalDoubleBinding(\.employeeCost).wrappedValue ?? 0.0, format: .currency(code: "USD"))
                                    .font(.headline)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
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
        } // end of body
    }
    
    // helper functions
    private func sectionLabel(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
        }
    }
    
    private func optionalStringBinding(_ kp: WritableKeyPath<Invoice, String?>) -> Binding<String> {
        Binding<String>(
            get: { self.invoice[keyPath: kp] ?? "" },
            set: { newValue in
                self.invoice[keyPath: kp] = newValue.isEmpty ? nil : newValue
            }
        )
    }
    
    private func optionalStringBinding<M>(_ root: WritableKeyPath<Invoice, M>,
                                              _ kp: WritableKeyPath<M, String?>
    ) -> Binding<String> {
        Binding(
            get: { invoice[keyPath: root][keyPath: kp] ?? "" },
            set: { invoice[keyPath: root][keyPath: kp] = $0.isEmpty ? nil : $0 }
        )
    }
    
    private func optionalDoubleBinding(_ kp: WritableKeyPath<Invoice, Double?>) -> Binding<Double?> {
        Binding<Double?>(
            get: { self.invoice[keyPath: kp] },
            set: { self.invoice[keyPath: kp] = $0 }
        )
    }
    
    private func optionalIntBinding(_ kp: WritableKeyPath<Invoice, Int?>) -> Binding<Int?> {
        Binding<Int?>(
            get: { self.invoice[keyPath: kp] },
            set: { self.invoice[keyPath: kp] = $0 }
        )
    }
    
    private func optionalDateBinding(_ kp: WritableKeyPath<Invoice, Date?>) -> Binding<Date> {
        Binding<Date>(
            get: { invoice[keyPath: kp] ?? Date() },
            set: { invoice[keyPath: kp] = $0 }
        )
    }
    
    
    private struct NumericTextField: View {
        @Binding var value: Double?
        var placeholder: String
        @State private var text: String = ""
        
        var body: some View {
            TextField(placeholder, text: Binding(
                get: { text },
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
            .onAppear { text = value != nil ? String(value!) : "" }
        }
    }
    
    // int variant
    private struct NumericTextFieldInt: View {
        @Binding var value: Int?
        var placeholder: String
        @State private var text: String = ""
        
        var body: some View {
            TextField(placeholder, text: Binding(
                get: { text },
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
            .onAppear { text = value != nil ? String(value!) : "" }
        }
    }
}


#Preview {
    InvoiceFormView(
        invoice: Invoice.sample(),
        onSave: { _ in },
        onDelete: { _ in }
    )
}
