//
//  Blockchain.swift
//  blockchain-swift-example
//
//  Created by Aleksey Pleshkov on 08.12.2017.
//

import Foundation
import CryptoSwift

public final class Blockchain {
    
    public var blocks: [Block]
    public var transactions: [Transaction]
    
    init() {
        self.blocks = []
        self.transactions = []
    }

    /// Mining new block.
    /// Compress all transactions in new block.
    func mineBlock() -> Block {
        // Init data for block
        let index: Int = (self.blocks.last?.index ?? self.blocks.count) + 1
        let lastBlockHash: String = (self.blocks.last?.hash ?? "0")
        let block: Block = Block(index: index, lastHash: lastBlockHash)
        // Generate hash for new block
        while block.isValid() == false {
            block.updateHash()
        }
        // Add all transactions in new block
        block.updateTransactions(transactions: self.transactions)
        self.transactions = []
        // End
        self.blocks.append(block)
        return block
    }
    
    /// Create transaction
    func sendTransaction(actor: String, target: String, count: Double) -> Transaction {
        let transaction = Transaction(actor: actor, target: target, count: count)
        self.transactions.append(transaction)
        return transaction
    }
    
    /// Validate all blocks in blockchain
    func validateBlockchain() -> (Bool, [Block], [Transaction]) {
        var incorrectBlocks: [Block] = []
        var incorrectTransactions: [Transaction] = []
        
        for block in self.blocks {
            let lastBlock: Block = blocks[block.index - 1]

            // Validate block
            if !block.isValid() || lastBlock.hash != block.hash {
                incorrectBlocks.append(block)
            }
            
            // Validate transactions in block
            var transactionsHash = ""
            for transaction in block.transactions {
                if !transaction.isValid() {
                    incorrectTransactions.append(transaction)
                }
                transactionsHash.append(transaction.hash)
            }
            
            // Validate full transactions hash
            let hash = transactionsHash.sha256()
            if block.transactionsHash != hash {
                if (incorrectBlocks.last?.index ?? 0) != block.index {
                    incorrectBlocks.append(block)
                }
            }
        }

        return (true, incorrectBlocks, incorrectTransactions)
    }
}








