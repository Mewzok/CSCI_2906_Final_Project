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

    func fetchInvoices(limit: Int? = nil, completion: @escaping (Result<[Invoice], Error>) -> Void) {
        var query = db.collection("invoices").order(by: "rkNumber", descending: true)
        if let limit = limit {
            query = query.limit(to: limit)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let docs = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            var invoices: [Invoice] = []
            for doc in docs {
                do {
                    let invoice = try doc.data(as: Invoice.self)
                    invoices.append(invoice)
                } catch {
                    print("InvoiceService: failed to decode document \(doc.documentID): \(error)")
                }
            }
            
            completion(.success(invoices))
        }
    }
    
    func addInvoice(_ invoice: Invoice, completion: @escaping (Error?) -> Void) {
        do {
            _ = try db.collection("invoices").addDocument(from: invoice, completion: { error in
                completion(error)
            })
        } catch {
            completion(error)
        }
    }
    
    func updateInvoice(_ invoice: Invoice, completion: @escaping (Error?) -> Void) {
        guard let id = invoice.id else {
            completion(NSError(domain: "InvoiceService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invoice missing id"]))
            return
        }
        do {
            try db.collection("invoices").document(id).setData(from: invoice, merge: true, completion: { error in
                completion(error)
            })
        } catch {
            completion(error)
        }
    }

    func deleteInvoice(id: String, completion: @escaping (Error?) -> Void) {
        db.collection("invoices").document(id).delete { error in
            completion(error)
        }
    }
}
