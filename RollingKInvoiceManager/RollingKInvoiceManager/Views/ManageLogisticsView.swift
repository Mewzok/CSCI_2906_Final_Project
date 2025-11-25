//
//  ManageLogisticsView.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/25/25.
//

import SwiftUI

struct ManageLogisticsView: View {
    enum Kind { case broker, shipper, receiver }
    let kind: Kind
    
    @StateObject var viewModel = HomeViewModel()
    
    @Binding var brokers: [Broker]
    @Binding var shippers: [Shipper]
    @Binding var receivers: [Receiver]
    @Environment(\.dismiss) private var dismiss
    
    @State private var editingBroker: Broker? = nil
    @State private var editingShipper: Shipper? = nil
    @State private var editingReceiver: Receiver? = nil
    @State private var showEditSheet = false
    
    var body: some View {
        List {
            switch kind {
            case .broker:
                ForEach(brokers) { broker in
                    HStack {
                        Text(broker.companyName)
                        Spacer()
                        Button("Edit") {
                            editingBroker = broker
                            showEditSheet = true
                        }
                        .buttonStyle(.bordered)
                        Button(role: .destructive) {
                            if let id = broker.id {
                                LogisticsService.shared.deleteBroker(id: id) { _ in
                                    DispatchQueue.main.async {
                                        brokers.removeAll { $0.id == id }
                                    }
                                }
                            }
                        } label: { Image(systemName: "trash") }
                    }
                }
            case .shipper:
                ForEach(shippers) { shipper in
                    HStack {
                        Text(shipper.companyName)
                        Spacer()
                        Button("Edit") {
                            editingShipper = shipper
                            showEditSheet = true
                        }
                        .buttonStyle(.bordered)
                        Button(role: .destructive) {
                            if let id = shipper.id {
                                LogisticsService.shared.deleteShipper(id: id) { _ in
                                    DispatchQueue.main.async {
                                        shippers.removeAll { $0.id == id }
                                    }
                                }
                            }
                        } label: { Image(systemName: "trash") }
                    }
                }
            case .receiver:
                ForEach(receivers) { receiver in
                    HStack {
                        Text(receiver.companyName)
                        Spacer()
                        Button("Edit") {
                            editingReceiver = receiver
                            showEditSheet = true
                        }
                        .buttonStyle(.bordered)
                        Button(role: .destructive) {
                            if let id = receiver.id {
                                LogisticsService.shared.deleteReceiver(id: id) { _ in
                                    DispatchQueue.main.async {
                                        receivers.removeAll { $0.id == id }
                                    }
                                }
                            }
                        } label: { Image(systemName: "trash") }
                    }
                }
            }
        }
        .navigationTitle(kind == .broker ? " Brokers" : kind == .shipper ? "Shippers" : "Receivers")
        .sheet(isPresented: $showEditSheet) {
            if let b = editingBroker {
                BrokerEditView(broker: b) { updated in
                    let trimmed = updated.persistedVariant()
                    LogisticsService.shared.updateBroker(trimmed) { success in
                        DispatchQueue.main.async {
                            if success {
                                if let idx = brokers.firstIndex(where: { $0.id == trimmed.id }) {
                                    brokers[idx] = trimmed
                                } else {
                                    viewModel.loadAllLogistics()
                                }
                            }
                            editingBroker = nil
                            showEditSheet = false
                        }
                    }
                }
            } else if let s = editingShipper {
                ShipperEditView(shipper: s) { updated in
                    let trimmed = updated.persistedVariant()
                    LogisticsService.shared.updateShipper(trimmed) { success in
                        DispatchQueue.main.async {
                            if success {
                                if let idx = shippers.firstIndex(where: { $0.id == trimmed.id }) {
                                    shippers[idx] = trimmed
                                } else {
                                    viewModel.loadAllLogistics()
                                }
                            }
                            editingShipper = nil
                            showEditSheet = false
                        }
                    }
                }
            } else if let r = editingReceiver {
                ReceiverEditView(receiver: r) { updated in
                    let trimmed = updated.persistedVariant()
                    LogisticsService.shared.updateReceiver(trimmed) { success in
                        DispatchQueue.main.async {
                            if success {
                                if let idx = receivers.firstIndex(where: { $0.id == trimmed.id }) {
                                    receivers[idx] = trimmed
                                } else {
                                    viewModel.loadAllLogistics()
                                }
                            }
                            editingReceiver = nil
                            showEditSheet = false
                        }
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
}
