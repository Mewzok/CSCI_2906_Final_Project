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
            guard let docs = snapshot?.documents
            else {
                completion(.success([]))
                return
            }
            
            var invoices: [Invoice] = []
            for doc in docs {
                let data = doc.data()
                if let inv = Invoice(from: data, id: doc.documentID) {
                    invoices.append(inv)
                } else {
                    print("InvoiceService: failed to parse document \(doc.documentID)")
                }
            }
            completion(.success(invoices))
        }
    }
    
    func addInvoice(_ invoice: Invoice, completion: @escaping (Error?) -> Void) {
        let data = invoice.toDictionary()
        db.collection("invoices").addDocument(data: data) { err in
            completion(err)
        }
    }
    
    func updateInvoice(_ invoice: Invoice, completion: @escaping (Error?) -> Void) {
        guard let id = invoice.id else {
            completion(NSError(domain: "InvoiceService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invoice missing id"]));
            return
        }
        let data = invoice.toDictionary()
        db.collection("invoices").document(id).setData(data, merge: true) { err in
                completion(err)
        }
    }
    
    func deleteInvoice(id: String, completion: @escaping (Error?) -> Void) {
        db.collection("invoices").document(id).delete { err in
                completion(err)
        }
    }
}
