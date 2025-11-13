//
//  Invoice.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import Foundation
import FirebaseFirestore

struct Company: Equatable {
    var companyName: String
    var address: String? = nil
    var phone: String? = nil
    var email: String? = nil
    var reeferTemperature: String? = nil
    var extraInfo: String? = nil
    
    init(companyName: String, address: String? = nil, phone: String? = nil, email: String? = nil, reeferTemperature: String? = nil, extraInfo: String? = nil) {
        self.companyName = companyName
        self.address = address
        self.phone = phone
        self.email = email
        self.reeferTemperature = reeferTemperature
        self.extraInfo = extraInfo
    }
    
    // initialize frmo Firestone document map
    init?(from dict: [String: Any]) {
        guard let name = dict["companyName"] as? String else {
            return nil
        }
        self.companyName = name
        self.address = dict["address"] as? String
        self.phone = dict["phone"] as? String
        self.email = dict["email"] as? String
        self.reeferTemperature = dict["reeferTemperature"] as? String
        self.extraInfo = dict["extraInfo"] as? String
    }
    
    // convert to dictionary to upload to Firestone
    func toDictionary() -> [String: Any] {
        var d: [String: Any] = ["companyName": companyName]
        if let v = address { d["address"] = v }
        if let v = phone { d["phone"] = v }
        if let v = email { d["email"] = v }
        if let v = reeferTemperature { d["reeferTemperature"] = v }
        if let v = extraInfo { d["extraInfo"] = v }
        return d
    }
}

struct Invoice: Identifiable, Equatable {
    var id: String? = nil
    var rkNumber: String
    var otherNumber: String? = nil
    var broker: Company
    var shipper: Company
    var receiver: Company
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
    
    // regular initializer
    init(id: String? = nil, rkNumber: String, otherNumber: String? = nil, broker: Company, shipper: Company, receiver: Company, gross: Double, pickupDate: Date, deliveryDate: Date, factorFee: Double, factorDate: Date? = nil, factorDue: Date? = nil, dispatchFee: Double? = nil, dispatchCost: Double? = nil, lumperCost: Double? = nil, employeeCost: Double? = nil, net: Double) {
        self.id = id
        self.rkNumber = rkNumber
        self.otherNumber = otherNumber
        self.broker = broker
        self.shipper = shipper
        self.receiver = receiver
        self.gross = gross
        self.pickupDate = pickupDate
        self.deliveryDate = deliveryDate
        self.factorFee = factorFee
        self.factorDate = factorDate
        self.factorDue = factorDue
        self.dispatchFee = dispatchFee
        self.dispatchCost = dispatchCost
        self.lumperCost = lumperCost
        self.employeeCost = employeeCost
        self.net = net
    }
    
    // initialize from Firestore document dictionary
    init?(from dict: [String: Any], id: String? = nil) {
        guard let rk = dict["rkNumber"] as? String else {
            return nil
        }
        self.rkNumber = rk
        
        self.otherNumber = dict["otherNumber"] as? String
        
        // broker shipper receiver
        guard let brokerDict = dict["broker"] as? [String: Any],
              let shipperDict = dict["shipper"] as? [String: Any],
              let receiverDict = dict["receiver"] as? [String: Any],
              let b = Company(from: brokerDict),
              let sh = Company(from: shipperDict),
              let r = Company(from: receiverDict)
        else {
            return nil
        }
        
        self.broker = b
        self.shipper = sh
        self.receiver = r
        
        // gross, allow int or double or string
        guard let grossVal = Invoice.numberToDouble(dict["gross"]) else {
            return nil
        }
        self.gross = grossVal
        
        // pickupDate and deliveryDate, accept Timestape or Date or ISO8601 string
        guard let pickup = Invoice.dateFromAny(dict["pickupDate"]),
              let delivery = Invoice.dateFromAny(dict["deliveryDate"])
        else {
            return nil
        }
        self.pickupDate = pickup
        self.deliveryDate = delivery
        
        // factorFee
        self.factorFee = Invoice.numberToDouble(dict["factorFee"]) ?? 0.0
        
        // optional dates
        self.factorDate = Invoice.dateFromAny(dict["factorDate"])
        self.factorDue = Invoice.dateFromAny(dict["factorDue"])
        
        self.dispatchFee = Invoice.numberToDouble(dict["dispatchFee"])
        self.dispatchCost = Invoice.numberToDouble(dict["dispatchCost"])
        self.lumperCost = Invoice.numberToDouble(dict["lumperCost"])
        self.employeeCost = Invoice.numberToDouble(dict["employeeCost"])
        
        // net
        guard let netVal = Invoice.numberToDouble(dict["net"])
        else {
            return nil
        }
        self.net = netVal
        
        self.id = id
    }
    
    // parsing helpers
    static func numberToDouble(_ value: Any?) -> Double? {
        guard let value = value
        else {
            return nil
        }
        if let d = value as? Double {
            return d
        }
        if let i = value as? Int {
            return Double(i)
        }
        if let s = value as? String {
            // remove commas and currency signs
            let cleaned = s.replacingOccurrences(of: "[,$ ]", with: "", options: .regularExpression)
            return Double(cleaned)
        }
        return nil
    }
    
    static func dateFromAny(_ value: Any?) -> Date? {
        guard let value = value
        else {
            return nil
        }
        if let ts = value as? Timestamp {
            return ts.dateValue()
        }
        if let d = value as? Date {
            return d
        }
        if let s = value as? String {
            // try ISO8601
            if let date = ISO8601DateFormatter().date(from: s) {
                return date
            }
            // try common formats
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = f.date(from: s) {
                return date
            }
        }
        return nil
    }
    
    // convert to dictionary to upload to Firestore
    func toDictionary() -> [String: Any] {
        var d: [String: Any] = [:]
        d["rkNumber"] = rkNumber
        if let other = otherNumber {
            d["otherNumber"] = other
        }
        
        d["broker"] = broker.toDictionary()
        d["shipper"] = shipper.toDictionary()
        d["receiver"] = receiver.toDictionary()
        
        d["gross"] = gross
        d["pickupDate"] = Timestamp(date: pickupDate)
        d["deliveryDate"] = Timestamp(date: deliveryDate)
        d["factorFee"] = factorFee
        
        if let fd = factorDate {
            d["factorDate"] = Timestamp(date: fd)
        }
        if let fdu = factorDue {
            d["factorDue"] = Timestamp(date: fdu)
        }
        if let dispatchFee = dispatchFee {
            d["dispatchFee"] = dispatchFee
        }
        if let dispatchCost = dispatchCost {
            d["dispatchCost"] = dispatchCost
        }
        if let lumperCost = lumperCost {
            d["lumperCost"] = lumperCost
        }
        if let employeeCost = employeeCost {
            d["employeeCost"] = employeeCost
        }
        
        d["net"] = net
        return d
    }
    
    // preview sample
    static func sample(id: String = UUID().uuidString) -> Invoice {
        let company = Company(companyName: "Logistics Company", address: "123 Main", phone: "555-5555", email: "info@email.com", reeferTemperature: "34F", extraInfo: "Notes")
        return Invoice(
            id: id,
            rkNumber: "RK021-M",
            otherNumber: "RK021-D",
            broker: company,
            shipper: company,
            receiver: company,
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
