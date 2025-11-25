//
//  Logistics+Saved.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/25/25.
//

import Foundation

// helpers to extract the saved portion and compare them
extension Broker {
    // create variant with only persisted fields
    func persistedVariant() -> Broker {
        return Broker(id: self.id,
                      companyName: self.companyName,
                      address: self.address,
                      phoneNumber: self.phoneNumber,
                      minReeferTemperature: nil,
                      maxReeferTemperature: nil,
                      email: self.email,
                      brokerName: self.brokerName,
                      poNumber: nil,
                      extraInfo: nil)
    }
    
    func persistedEquals(_ other: Broker) -> Bool {
        return self.companyName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ==
        other.companyName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        && (self.address ?? "") == (other.address ?? "")
        && (self.phoneNumber ?? "") == (other.phoneNumber ?? "")
        && (self.email ?? "") == (other.email ?? "")
        && (self.brokerName ?? "") == (other.brokerName ?? "")
    }
}

extension Shipper {
    func persistedVariant() -> Shipper {
        return Shipper(id: self.id,
                       companyName: self.companyName,
                       address: self.address,
                       phoneNumber: self.phoneNumber,
                       minReeferTemperature: nil,
                       maxReeferTemperature: nil,
                       deliveryAddress: nil,
                       pickupDateTime: nil,
                       approximateWeight: nil,
                       confirmationNumber: nil,
                       extraInfo: nil)
    }
    
    func persistedEquals(_ other: Shipper) -> Bool {
        return self.companyName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        == other.companyName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        && (self.address ?? "") == (other.address ?? "")
        && (self.phoneNumber ?? "") == (other.phoneNumber ?? "")
    }
}

extension Receiver {
    func persistedVariant() -> Receiver {
        return Receiver(id: self.id,
                        companyName: self.companyName,
                        address: self.address,
                        phoneNumber: self.phoneNumber,
                        minReeferTemperature: nil,
                        maxReeferTemperature: nil,
                        deliveryAddress: nil,
                        pickupDateTime: nil,
                        approximateWeight: nil,
                        pickupNumber: nil,
                        extraInfo: nil)
    }
    
    func persistedEquals(_ other: Receiver) -> Bool {
        return self.companyName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        == other.companyName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        && (self.address ?? "") == (other.address ?? "")
        && (self.phoneNumber ?? "") == (other.phoneNumber ?? "")
    }
}
