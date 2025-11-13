//
//  Invoice.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import Foundation
import FirebaseFirestore

struct Invoice: Identifiable, Codable, Equatable {
    @DocumentID var id: String? = nil
    var rkNumber: String
    var otherNumber: String? = nil
    var broker: Broker
    var shipper: Shipper
    var receiver: Receiver
    var gross: Double
    var pickupDate: Date
    var deliveryDate: Date
    var factorFee: Double
    var factorDate: Date? = nil
    var factorDue: Date? = nil
    var dispatchFee: Double? = nil
    var dispatchCost: Double? = nil
    var lumperCost: Double? = nil
    var employeeCost: Double? = nil
    var net: Double
    
    // preview sample
    static func sample(id: String = UUID().uuidString) -> Invoice {
        let broker = Broker(companyName: "Broker Company", email: "broker@email.com", poNumber: "PO1234")
        let shipper = Shipper(companyName: "Shipper Company", pickupDateTime: Date())
        let receiver = Receiver(companyName: "Receiver Company", deliveryAddress: "789 Address")
        return Invoice(
            id: id,
            rkNumber: "RK021-M",
            otherNumber: "RK021-D",
            broker: broker,
            shipper: shipper,
            receiver: receiver,
            gross: 1000,
            pickupDate: ISO8601DateFormatter().date(from: "2003-01-02T00:00:00Z") ?? Date(),
            deliveryDate: ISO8601DateFormatter().date(from: "2003-01-30T00:00:00Z") ?? Date(),
            factorFee: 2.5,
            factorDate: nil,
            factorDue: nil,
            dispatchFee: 5.0,
            dispatchCost: nil,
            lumperCost: 50,
            employeeCost: nil,
            net: 900
        )
    }
}
