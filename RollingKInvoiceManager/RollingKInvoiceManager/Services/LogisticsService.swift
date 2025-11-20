//
//  LogisticsService.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/20/25.
//

import Foundation
import FirebaseFirestore

class LogisticsService {
    static let shared = LogisticsService()
    private let db = Firestore.firestore()
    
    // brokers
    func fetchBrokers(completion: @escaping ([Broker]) -> Void) {
        db.collection("brokers").getDocuments { snapshot, error in
            if let docs = snapshot?.documents {
                let brokers = docs.compactMap { try? $0.data(as: Broker.self) }
                completion(brokers)
            } else {
                completion([])
            }
        }
    }
    
    func addBroker(_ broker: Broker, completion: @escaping (Bool) -> Void) {
        do {
            _ = try db.collection("brokers").addDocument(from: broker, completion: { error in
                completion(error == nil)
            })
        } catch {
            completion(false)
        }
    }
    
    func updateBroker(_ broker: Broker, completion: @escaping (Bool) -> Void) {
        guard let id = broker.id else {
            completion(false)
            return
        }
        do {
            try db.collection("brokers").document(id).setData(from: broker) { error in
                completion(error == nil)
            }
        } catch {
            completion(false)
        }
    }
    
    func deleteBroker(id: String, completion: @escaping (Bool) -> Void) {
        db.collection("brokers").document(id).delete { error in
            completion(error == nil)
        }
    }
    
    // shippers
    func fetchShippers(completion: @escaping ([Shipper]) -> Void) {
        db.collection("shippers").getDocuments { snapshot, error in
            if let docs = snapshot?.documents {
                let shippers = docs.compactMap { try? $0.data(as: Shipper.self) }
                completion(shippers)
            } else {
                completion([])
            }
        }
    }
    
    func addShipper(_ shipper: Shipper, completion: @escaping (Bool) -> Void) {
        do {
            _ = try db.collection("shippers").addDocument(from: shipper, completion: { error in
                completion(error == nil)
            })
        } catch {
            completion(false)
        }
    }
    
    func updateShipper(_ shipper: Shipper, completion: @escaping (Bool) -> Void) {
        guard let id = shipper.id else {
            completion(false)
            return
        }
        do {
            try db.collection("shippers").document(id).setData(from: shipper) { error in
                completion(error == nil)
            }
        } catch {
            completion(false)
        }
    }
    
    func deleteShipper(id: String, completion: @escaping (Bool) -> Void) {
        db.collection("shippers").document(id).delete { error in
            completion(error == nil)
        }
    }
    
    // receivers
    func fetchReceivers(completion: @escaping ([Receiver]) -> Void) {
        db.collection("receivers").getDocuments { snapshot, error in
            if let docs = snapshot?.documents {
                let receivers = docs.compactMap { try? $0.data(as: Receiver.self) }
                completion(receivers)
            } else {
                completion([])
            }
        }
    }
    
    func addReceiver(_ receiver: Receiver, completion: @escaping (Bool) -> Void) {
        do {
            _ = try db.collection("receivers").addDocument(from: receiver, completion: { error in
                completion(error == nil)
            })
        } catch {
            completion(false)
        }
    }
    
    func updateReceiver(_ receiver: Receiver, completion: @escaping (Bool) -> Void) {
        guard let id = receiver.id else {
            completion(false)
            return
        }
        do {
            try db.collection("receivers").document(id).setData(from: receiver) { error in
                completion(error == nil)
            }
        } catch {
            completion(false)
        }
    }
    
    func deleteReceiver(id: String, completion: @escaping (Bool) -> Void) {
        db.collection("receivers").document(id).delete { error in
            completion(error == nil)
        }
    }
}
