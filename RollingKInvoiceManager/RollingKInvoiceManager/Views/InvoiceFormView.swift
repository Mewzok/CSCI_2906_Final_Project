//
//  InvoiceFormView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/13/25.
//  Form to input/edit invoice fields

import SwiftUI

struct InvoiceFormView: View {
    // create local copy so edits are safe until used
    @Binding var invoice: Invoice
    @Binding var brokers: [Broker]
    @Binding var shippers: [Shipper]
    @Binding var receivers: [Receiver]
    let onSave: (Invoice) -> Void
    let onDelete: ((String) -> Void)?
    @Environment(\.dismiss) private var dismiss
    
    // section visibility, create is expanded, edit is collapsed
    @State private var showInvoiceInfo: Bool = true
    @State private var showBroker: Bool = true
    @State private var showShipper: Bool = true
    @State private var showReceiver: Bool = true
    @State private var showFinances: Bool = true
    @State private var showDates: Bool = true
    
    // toggles for optional fees
    @State private var factorEnabled: Bool = false
    @State private var dispatchEnabled: Bool = false
    
    // selected logistics for pickers
    @State private var selectedBrokerID: String? = nil
    @State private var selectedShipperID: String? = nil
    @State private var selectedReceiverID: String? = nil
    
    // alerts
    private enum SaveItem { case addBroker, addShipper, addReceiver
        case updateBroker(id: String), updateShipper(id: String), updateReceiver(id: String) }
    @State private var saveQueue: [SaveItem] = []
    @State private var currentSaveItem: SaveItem? = nil
    @State private var showSaveConfirm: Bool = false
    @State private var saveInProgress: Bool = false
    
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
                // broker picker
                Picker("Broker", selection: $selectedBrokerID) {
                    Text("New Broker").tag(nil as String?)
                    ForEach(brokers) { broker in
                        Text(broker.companyName).tag(broker.id)
                    }
                }
                .onChange(of: selectedBrokerID) { id in
                    if let b = brokers.first(where: { $0.id == id }) {
                        invoice.broker = b
                    } else {
                        invoice.broker = Broker(companyName: "")
                    }
                }
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
                // broker name
                HStack {
                    Text("Broker Name")
                    Spacer()
                    TextField("Name", text: optionalStringBinding(\.broker.brokerName))
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
                // shipper picker
                Picker("Shipper", selection: $selectedShipperID) {
                    Text("New Shipper").tag(nil as String?)
                    ForEach(shippers) { shipper in
                        Text(shipper.companyName).tag(shipper.id)
                    }
                }
                .onChange(of: selectedShipperID) { id in
                    if let s = shippers.first(where: { $0.id == id }) {
                        invoice.shipper = s
                    } else {
                        invoice.shipper = Shipper(companyName: "")
                    }
                }
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
                // shipper phoneNumber
                HStack {
                    Text("Phone Number")
                    Spacer()
                    TextField("Phone", text: optionalStringBinding(\.shipper.phoneNumber))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                //shipper confirmationNumber
                HStack {
                    Text("Confirmation #")
                    Spacer()
                    NumericTextFieldInt(value: optionalIntBinding(\.shipper.confirmationNumber), placeholder: "Confirmation #")
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
                    optionalDatePicker(label: "", date: $invoice.shipper.pickupDateTime)
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
                // shipper minReeferTemperature
                HStack {
                    Text("Shipper Min Temperature")
                    Spacer()
                    NumericTextField(value: optionalDoubleBinding(\.shipper.minReeferTemperature), placeholder: "Reefer min")
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 90)
                    Text("°F").foregroundColor(.secondary)
                }
                // shipper maxReeferTemperature
                HStack {
                    Text("Shipper Max Temperature")
                    Spacer()
                    NumericTextField(value: optionalDoubleBinding(\.shipper.maxReeferTemperature), placeholder: "Reefer max")
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 90)
                    Text("°F").foregroundColor(.secondary)
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
                // receiver picker
                Picker("Receiver", selection: $selectedReceiverID) {
                    Text("New Receiver").tag(nil as String?)
                    ForEach(receivers) { receiver in
                        Text(receiver.companyName).tag(receiver.id)
                    }
                }
                .onChange(of: selectedReceiverID) { id in
                    if let r = receivers.first(where: { $0.id == id }) {
                        invoice.receiver = r
                    } else {
                        invoice.receiver = Receiver(companyName: "")
                    }
                }
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
                // receiver phoneNumber
                HStack {
                    Text("Phone Number")
                    Spacer()
                    TextField("Phone", text: optionalStringBinding(\.receiver.phoneNumber))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 180)
                }
                // receiver pickupNumber
                HStack {
                    Text("Pickup #")
                    Spacer()
                    NumericTextFieldInt(value: optionalIntBinding(\.receiver.pickupNumber), placeholder: "Pickup #")
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
                    optionalDatePicker(label: "", date: $invoice.receiver.pickupDateTime)
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
                // broker minReeferTemperature
                HStack {
                    Text("Receiver Min Temperature")
                    Spacer()
                    NumericTextField(value: optionalDoubleBinding(\.receiver.minReeferTemperature), placeholder: "Reefer min")
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 90)
                    Text("°F").foregroundColor(.secondary)
                }
                // receiver maxReeferTemperature
                HStack {
                    Text("Receiver Max Temperature")
                    Spacer()
                    NumericTextField(value: optionalDoubleBinding(\.receiver.maxReeferTemperature), placeholder: "Reefer max")
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 90)
                    Text("°F").foregroundColor(.secondary)
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
                        GrossTextField(value: $invoice.gross, placeholder: "Gross")
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
                        optionalDatePicker(label: "Pickup Date", date: $invoice.pickupDate)
                    }
                    HStack {
                        optionalDatePicker(label: "Delivery Date", date: $invoice.deliveryDate)
                    }
                    HStack {
                        optionalDatePicker(label: "Factor Date", date: $invoice.factorDate)
                    }
                    HStack {
                        optionalDatePicker(label: "Factor Due", date: $invoice.factorDue)
                    }
                }
                .padding(.top, 8)
            } label: {
                sectionLabel("Dates")
            }
            .padding(.horizontal)
        }
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
                                beginSaveProcess()
                            } label: {
                                Text("Save")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .alert(isPresented: $showSaveConfirm) {
                                // create title and message from currentSaveItem
                                let title: String
                                let message: String
                                switch currentSaveItem {
                                case .addBroker:
                                    title = "Save new Broker?"
                                    message = "Would you like to save broker '\(invoice.broker.companyName)'?"
                                case .updateBroker:
                                    title = "Update Broker?"
                                    message = "Would you like to update broker '\(invoice.broker.companyName)' with current fields?"
                                case .addShipper:
                                    title = "Save new Shipper?"
                                    message = "Would you like to save shipper '\(invoice.shipper.companyName)'?"
                                case .updateShipper:
                                    title = "Update Shipper?"
                                    message = "Would you like to update shipper '\(invoice.shipper.companyName)' with current fields?"
                                case .addReceiver:
                                    title = "Save new Receiver?"
                                    message = "Would you like to save receiver '\(invoice.receiver.companyName)'?"
                                case .updateReceiver:
                                    title = "Update Receiver?"
                                    message = "Would you like to update receiver '\(invoice.receiver.companyName)' with current fields?"
                                case .none:
                                    title = ""
                                    message = ""
                                }
                                
                                return Alert(
                                    title: Text(title),
                                    message: Text(message),
                                    primaryButton: .default(Text("Yes")) {
                                        handleConfirmSaveCurrentItem()
                                    },
                                    secondaryButton: .cancel {
                                        handleSkipSaveCurrentItem()
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground).shadow(radius: 0.5))
                } // end of vstack
                .navigationTitle(invoice.id == nil ? "New Invoice" : "Edit Invoice")
            } // end of navigationview
        } // end of body
        .onAppear {
            // expand or collapse sections based on if new invoice or editing one
            let isNew = (invoice.id == nil)
            showInvoiceInfo = isNew
            showBroker = isNew
            showShipper = isNew
            showReceiver = isNew
            showFinances = isNew
            showDates = isNew
            
            factorEnabled = (invoice.factorFee ?? 0) > 0
            dispatchEnabled = (invoice.dispatchFee ?? 0) > 0
            
            selectedBrokerID = invoice.broker.id
            selectedShipperID = invoice.shipper.id
            selectedReceiverID = invoice.receiver.id
        }
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
    
    private struct optionalDatePicker: View {
        var label: String
        @Binding var date: Date?
        var defaultDate: Date = Date()
        
        @State private var showPicker = false
        @State private var tempDate: Date = Date()
        
        var body: some View {
            HStack {
                Text(label)
                Spacer()
                if let nonNilDate = date {
                    DatePicker(label, selection: Binding(
                        get: { nonNilDate },
                        set: { date = $0 }),
                               displayedComponents: [.date, .hourAndMinute]
                               )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .frame(maxHeight: 32)
                    .frame(maxWidth: 200)
                    Button(role: .destructive) {
                        self.date = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    Button("Set Date") {
                        tempDate = defaultDate
                        showPicker = true
                    }
                    .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $showPicker) {
                VStack {
                    DatePicker("Select Date", selection: $tempDate,
                               displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    Button("Done") {
                        date = tempDate
                        showPicker = false
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
    }
    
    private struct GrossTextField: View {
        @Binding var value: Double
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
            .onAppear {
                text = value == 0 ? "" : String(value)
            }
        }
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
    
    private func save() {
        // store computed net back on main model before saving
        var saved = invoice
        saved.net = computedNet
        saved.dispatchCost = computedDispatchCost
        onSave(saved)
        dismiss()
    }
    
    private func beginSaveProcess() {
        guard !saveInProgress
        else {
            return
        }
        saveQueue = []
        
        // build queue for new items in order: broker, shipper, receiver
        // also check for creating new or modifying old
        let brokerName = invoice.broker.companyName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !brokerName.isEmpty {
            if let selectedID = selectedBrokerID, let stored = brokers.first(where: { $0.id == selectedID }) {
                if stored != invoice.broker {
                    saveQueue.append(.updateBroker(id: selectedID))
                }
            } else {
                // not selected or selected is nil, maybe new
                let existsByName = brokers.contains { $0.companyName.lowercased() == brokerName.lowercased() }
                if !existsByName {
                    saveQueue.append(.addBroker)
                }
            }
        }
        
        let shipperName = invoice.shipper.companyName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !shipperName.isEmpty {
            if let selectedID = selectedShipperID, let stored = shippers.first(where: { $0.id == selectedID }) {
                if stored != invoice.shipper {
                    saveQueue.append(.updateShipper(id: selectedID))
                }
            } else {
                // not selected or selected is nil, maybe new
                let existsByName = shippers.contains { $0.companyName.lowercased() == shipperName.lowercased() }
                if !existsByName {
                    saveQueue.append(.addShipper)
                }
            }
        }
        
        let receiverName = invoice.receiver.companyName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !receiverName.isEmpty {
            if let selectedID = selectedReceiverID, let stored = receivers.first(where: { $0.id == selectedID }) {
                if stored != invoice.receiver {
                    saveQueue.append(.updateReceiver(id: selectedID))
                }
            } else {
                // not selected or selected is nil, maybe new
                let existsByName = receivers.contains { $0.companyName.lowercased() == receiverName.lowercased() }
                if !existsByName {
                    saveQueue.append(.addReceiver)
                }
            }
        }
        
        if saveQueue.isEmpty {
            // nothing is new, just save the invoice
            save()
        } else {
            saveInProgress = true
            presentNextSaveItem()
        }
    }
    
    private func presentNextSaveItem() {
        if saveQueue.isEmpty {
            // current save is done
            saveInProgress = false
            save()
            return
        }
        currentSaveItem = saveQueue.removeFirst()
        showSaveConfirm = true
    }
    
    private func handleConfirmSaveCurrentItem() {
        guard let item = currentSaveItem
        else {
            presentNextSaveItem()
            return
        }
        showSaveConfirm = false
        
        switch item {
        case .addBroker:
            LogisticsService.shared.addBroker(invoice.broker) {
                success in
                DispatchQueue.main.async {
                    if success {
                        brokers.append(invoice.broker)
                    }
                    presentNextSaveItem()
                }
            }
        case .updateBroker(let id):
            var updated = invoice.broker
            updated.id = id
            LogisticsService.shared.updateBroker(updated) {
                success in
                DispatchQueue.main.async {
                    if success {
                        // refresh local copy
                        if let idx = brokers.firstIndex(where: {
                            $0.id == id
                        }) {
                            brokers[idx] = updated
                        }
                    }
                    presentNextSaveItem()
                }
            }
        case .addShipper:
            LogisticsService.shared.addShipper(invoice.shipper) {
                success in
                DispatchQueue.main.async {
                    if success {
                        shippers.append(invoice.shipper)
                    }
                    presentNextSaveItem()
                }
            }
        case .updateShipper(let id):
            var updated = invoice.shipper
            updated.id = id
            LogisticsService.shared.updateShipper(updated) {
                success in
                DispatchQueue.main.async {
                    if success {
                        // refresh local copy
                        if let idx = shippers.firstIndex(where: {
                            $0.id == id
                        }) {
                            shippers[idx] = updated
                        }
                    }
                    presentNextSaveItem()
                }
            }
        case .addReceiver:
            LogisticsService.shared.addReceiver(invoice.receiver) {
                success in
                DispatchQueue.main.async {
                    if success {
                        receivers.append(invoice.receiver)
                    }
                    presentNextSaveItem()
                }
            }
        case .updateReceiver(let id):
            var updated = invoice.receiver
            updated.id = id
            LogisticsService.shared.updateReceiver(updated) {
                success in
                DispatchQueue.main.async {
                    if success {
                        // refresh local copy
                        if let idx = receivers.firstIndex(where: {
                            $0.id == id
                        }) {
                            receivers[idx] = updated
                        }
                    }
                    presentNextSaveItem()
                }
            }
        }
    }
    
    private func handleSkipSaveCurrentItem() {
        // no to save, skip saving current item and continue to next
        showSaveConfirm = false
        presentNextSaveItem()
    }
}


#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State var invoice = Invoice.sample()
    @State var brokers = [Invoice.sample().broker]
    @State var shippers = [Invoice.sample().shipper]
    @State var receivers = [Invoice.sample().receiver]
    var body: some View {
        InvoiceFormView(
            invoice: $invoice,
            brokers: $brokers,
            shippers: $shippers,
            receivers: $receivers,
            onSave: { _ in },
            onDelete: { _ in }
        )
    }
}
