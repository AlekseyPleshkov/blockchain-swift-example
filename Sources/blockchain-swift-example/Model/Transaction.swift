//
//  Transaction.swift
//  blockchain-swift-example
//
//  Created by Aleksey Pleshkov on 08.12.2017.
//

import Foundation

public final class Transaction: Encodable {
    public let actor: String
    public let target: String
    public var count: Double
    public let hash: String
    
    init(actor: String, target: String, count: Double) {
        self.actor = actor
        self.target = target
        self.count = count
        self.hash = "\(self.actor)\(self.target)\(self.count)".sha256()
    }
    
    func isValid() -> Bool {
        let hash = "\(self.actor)\(self.target)\(self.count)".sha256()
        return self.hash == hash ? true : false
    }
}
