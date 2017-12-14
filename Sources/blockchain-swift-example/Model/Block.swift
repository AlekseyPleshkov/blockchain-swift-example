//
//  Block.swift
//  blockchain-swift-examplePackageDescription
//
//  Created by Aleksey Pleshkov on 08.12.2017.
//

import Foundation
import CryptoSwift

public final class Block: Encodable {
    public let index: Int
    public var time: Double
    public var nonce: Int
    public var hash: String
    public let lastHash: String
    public var transactionsHash: String
    public var transactions: [Transaction]
    
    init(index: Int, lastHash: String) {
        // Initial data
        self.index = index
        self.lastHash = lastHash
        // Updated after generate nonce number and hash
        self.time = 0
        self.nonce = 0
        self.hash = String()
        self.transactions = []
        self.transactionsHash = String()
    }
    
    /// Generate hash for block.
    /// Update nonce number and time create block.
    public func updateHash() {
        self.nonce += 1
        self.time = NSDate().timeIntervalSince1970
        self.hash = "\(self.index)\(self.time)\(self.nonce)\(self.lastHash)".sha256()
    }
    
    /// Create hash all transactions.
    /// Add all transactions in block
    public func updateTransactions(transactions: [Transaction]) {
        var hash = String()
        for transaction in transactions {
            hash.append(transaction.hash)
        }
        self.transactions = transactions
        self.transactionsHash = hash.sha256()
    }
    
    /// Validate data of block
    public func isValid() -> Bool {
        let hash = "\(self.index)\(self.time)\(self.nonce)\(self.lastHash)".sha256()
        return self.hash == hash && hash.prefix(3) == "000" ? true : false
    }
}

extension Block {
    func toJson() -> String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        let json = String(data: data, encoding: .utf8)!
        return json
    }
}
