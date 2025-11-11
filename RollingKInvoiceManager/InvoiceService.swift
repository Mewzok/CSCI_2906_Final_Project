//
//  InvoiceService.swift
//  RollingKInvoiceManager
//
//  Created by Student on 11/11/25.
//

import Foundation
import FirebaseFirestore

class InvoiceService {
    static let shared = InvoiceService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func fetchInvoices(completion: @escaping ([Invoice]) -> Void) {
        db.collection("Invoices").order(by: "rkNumber", descending: true).getDocuments { snapshot, error in guard let documents = snapshot?.documents else {
            completion([])
            return
        }
            let invoices = documents.compactMap { try? $0.data(as: Invoice.self) }
            completion(invoices)
        }
    }
    
    func addInvoice(_ invoice: Invoice, completion: ((Error?) -> Void)? = nil) {
        do {
            _ = try db.collection("Invoices").addDocument(from: invoice, completion: completion)
        } catch {
            completion?(error)
        }
    }
    
    func updateInvoice(_ invoice: Invoice, completion: ((Error?) -> Void)? = nil) {
        guard let id = invoice.id else { return }
        do {
            try db.collection("Invoices").document(id).setData(from: invoice, completion: completion)
        } catch {
            completion?(error)
        }
    }
}
