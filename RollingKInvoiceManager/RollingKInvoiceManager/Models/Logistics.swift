//
//  Logistics.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/13/25.
//

import Foundation
import FirebaseFirestore

struct Broker: Identifiable, Codable, Equatable {
    @DocumentID var id: String? = nil
    var companyName: String
    var address: String?
    var phoneNumber: String?
    var minReeferTemperature: Double?
    var maxReeferTemperature: Double?
    var email: String?
    var brokerName: String?
    var poNumber: Int?
    var extraInfo: String?
}

struct Shipper: Identifiable, Codable, Equatable {
    @DocumentID var id: String? = nil
    var companyName: String
    var address: String?
    var phoneNumber: String?
    var minReeferTemperature: Double?
    var maxReeferTemperature: Double?
    var deliveryAddress: String?
    var pickupDateTime: Date?
    var approximateWeight: Double?
    var confirmationNumber: Int?
    var extraInfo: String?
}

struct Receiver: Identifiable, Codable, Equatable {
    @DocumentID var id: String? = nil
    var companyName: String
    var address: String?
    var phoneNumber: String?
    var minReeferTemperature: Double?
    var maxReeferTemperature: Double?
    var deliveryAddress: String?
    var pickupDateTime: Date?
    var approximateWeight: Double?
    var pickupNumber: Int?
    var extraInfo: String?
}
