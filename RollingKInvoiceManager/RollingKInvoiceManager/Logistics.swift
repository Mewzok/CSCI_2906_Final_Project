//
//  Logistics.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/13/25.
//

import Foundation

struct Broker: Codable, Equatable {
    var companyName: String
    var address: String?
    var phoneNumber: String?
    var reeferTemperature: String?
    var email: String?
    var brokerName: String?
    var poNumber: String?
    var extraInfo: String?
}

struct Shipper: Codable, Equatable {
    var companyName: String
    var address: String?
    var phoneNumber: String?
    var reeferTemperature: String?
    var deliveryAddress: String?
    var pickupDateTime: Date?
    var approximateWeight: String?
    var confirmationNumber: String?
    var extraInfo: String?
}

struct Receiver: Codable, Equatable {
    var companyName: String
    var address: String?
    var phoneNumber: String?
    var reeferTemperature: String?
    var deliveryAddress: String?
    var pickupDateTime: Date?
    var approximateWeight: String?
    var pickupNumber: String?
    var extraInfo: String?
}
