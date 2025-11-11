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
        var query = db.collection("Invoices").order(by: "rkNumber", descending: true)
        
        if let limit = limit {
            query = query.limit(to: limit)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let invoices: [Invoice] = snapshot?.documents.compactMap { doc in
                do {
                    let data = doc.data()
                    let json = try JSONSerialization.data(withJSONObject: data)
                    return try JSONDecoder().decode(Invoice.self, from: json)
                } catch {
                    print("Decoding error:", error)
                    return nil
                }
            } ?? []
            
            completion(.success(invoices))
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
    
    func deleteInvoice(id: String, completion: @escaping (Error?) -> Void) {
        db.collection("Invoices").document(id).delete(completion: completion)
    }
}
