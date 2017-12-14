/// ////////////////////////////////////////////
/// Blockchain Swift Example
/// AlekseyPleshkov
/// http://alekseypleshkov.ru
/// ////////////////////////////////////////////

import Foundation
import CryptoSwift
import Swifter


///
/// Start http server
///

let server = try Swifter()
let blockchain = Blockchain()
let encoder = JSONEncoder()

/// Get all blocks in blockchain
server.get("/blocks") { _, request, responder in
    /// Convert blockchain blocks to json
    let blocksData = try! encoder.encode([blockchain.blocks])
    let blocksJson = String(data: blocksData, encoding: .utf8)!
    // Print result
    responder(TextResponse(200, blocksJson))
    print("\(blocksJson)")
}

/// Get all transactions in blockchain
server.get("/transactions") { _, request, responder in
    /// Convert blockchain blocks to json
    let transactionsData = try! encoder.encode([blockchain.transactions])
    let transactionsJson = String(data: transactionsData, encoding: .utf8)!
    // Print result
    responder(TextResponse(200, transactionsJson))
    print("\(transactionsJson)")
}

/// Mine new block
server.get("/mine") { _, request, responder in
    let block = blockchain.mineBlock()
    
    /// Convert block to json
    let blockData = try! encoder.encode(block)
    let blockJson = String(data: blockData, encoding: .utf8)!
    /// Print result
    responder(TextResponse(200, blockJson))
    print("\(blockJson)")
}

/// Send new transaction
server.get("/transaction") { _, request, responder in
    var actor: String? = nil
    var target: String? = nil
    var count: Double = 0
    
    for query in request.query {
        if query.0 == "actor" {
            actor = query.1
        }
        
        if query.0 == "target" {
            target = query.1
        }
        
        if query.0 == "count" {
            count = Double(query.1)!
        }
    }
    
    if let actorData: String = actor, let targetData: String = target {
        let transaction = blockchain.sendTransaction(actor: actorData, target: targetData, count: count)
        /// Convert transaction to json
        let transactionData = try! encoder.encode(transaction)
        let transactionJson = String(data: transactionData, encoding: .utf8)!
        /// Print result
        responder(TextResponse(200, "\(transactionJson)"))
        print("\(transactionJson)")
    }
}

/// Validate blockchain
server.get("/validateBlockchain") { _, request, responder in
    let isValid = blockchain.validateBlockchain()
    /// Print result
    responder(TextResponse(200, "\(isValid)"))
    print("\(isValid)")
}

/// Test
/// For changed blocks data
server.get("/changeBlocks") { _, request, responder in
    for block in blockchain.blocks {
        block.time = 0
    }
    /// Print result
    responder(TextResponse(200, "Block changed"))
}

/// Test
/// For changed blocks data
server.get("/changeTransactions") { _, request, responder in
    for block in blockchain.blocks {
        for transaction in block.transactions {
            transaction.count += 100
        }
    }
    /// Print result
    responder(TextResponse(200, "Transactions changed"))
}

/// Start server
while true {
    try server.loop()
}

