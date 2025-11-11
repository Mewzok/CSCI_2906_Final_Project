//
//  Invoice.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import Foundation
import FirebaseFirestore

struct Invoice: Identifiable, Codable {
    @DocumentID var id: String?
    var rkNumber: String
    var gross: Double
    var pickupDate: Date
    var deliveryDate: Date
    var net: Double
    var factorFee: Double
    var dispatchFee: Double
    var broker: Company
    var shipper: Company
    var receiver: Company
}

struct Company: Codable {
    var companyName: String
    var address: String?
    var phone: String?
    var email: String?
    var reeferTemperature: String?
    var extraInfo: String?
}
