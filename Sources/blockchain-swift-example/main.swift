/// ////////////////////////////////////////////
/// Blockchain Swift Example
/// AlekseyPleshkov
/// http://alekseypleshkov.ru
/// ////////////////////////////////////////////

import Foundation
import CryptoSwift
import Swifter

/// Create SHA256 hash for new block
func generateHashForBlock(index: Int, prevHash: String, timestamp: Double, data: String) -> String {
    return "\(index)_\(prevHash)_\(timestamp)_\(data)".sha256()
}

/// Get start index blockchain block
func getStartBlock() -> BlockchainBlock {
    let newBlockHash = generateHashForBlock(index: 0, prevHash: "0", timestamp: 1, data: "Init start block")
    return BlockchainBlock(index: 0, prevHash: "0", timestamp: 1, data: "Init start block", hash: newBlockHash)
}

/// List of blocks
var blockchain: [BlockchainBlock] = [getStartBlock()]

/// Return last block in list
func getLastBlock() -> BlockchainBlock {
    return blockchain[blockchain.count - 1]
}

/// Create next block after last
func generateNextBlock(data: String) -> BlockchainBlock {
    let prevBlock = getLastBlock()
    let nextIndex = prevBlock.index + 1
    let nextTimestamp: Double = NSDate().timeIntervalSince1970 * 1000
    let nextHash: String = generateHashForBlock(index: nextIndex, prevHash: prevBlock.hash, timestamp: nextTimestamp, data: data)
    return BlockchainBlock(index: nextIndex, prevHash: prevBlock.hash, timestamp: nextTimestamp, data: data, hash: nextHash)
}

/// Check validataion a new block
func isValidNewBlock(newBlock: BlockchainBlock, prevBlock: BlockchainBlock) -> Bool {
    let newBlockHash = generateHashForBlock(index: newBlock.index, prevHash: newBlock.prevHash, timestamp: newBlock.timestamp, data: newBlock.data)
    if (prevBlock.index + 1 != newBlock.index) {
        print("Invalid index of new block")
        return false
    } else if (prevBlock.hash != newBlock.prevHash) {
        print("Invalid prev hash")
        return false
    } else if (newBlockHash != newBlock.hash) {
        print("Invalid hash: \(newBlockHash) / \(newBlock.hash)")
        return false
    }
    return true
}

/// Add new block in block list
func addBlock(newBlock: BlockchainBlock) {
    if (isValidNewBlock(newBlock: newBlock, prevBlock: getLastBlock())) {
        blockchain.append(newBlock)
    }
}

///
/// Start http server
///

let server = try Swifter()

/// Get blockchain list
server.get("/getBlocks") { _, request, responder in
    /// Convert array list blockchain to json
    let encoder = JSONEncoder()
    let blocksData = try! encoder.encode(blockchain)
    let blocks = String(data: blocksData, encoding: .utf8)!
    /// Result
    responder(TextResponse(200, blocks))
    print("Getting blocks list")
    print("\(blocks)")
}

/// Add new block in blockchain list
server.get("/addBlock") { params, request, responder in
    var dataQuery: String? = nil
    /// Get data from request parameters
    for query in request.query {
        if query.0 == "data" {
            dataQuery = query.1
        }
    }
    
    /// Create new block
    if let data: String = dataQuery {
        /// Generate new block and convert to json
        let newBlock = generateNextBlock(data: data)
        let encoder = JSONEncoder()
        let blockData = try! encoder.encode(newBlock)
        let block = String(data: blockData, encoding: .utf8)!
        /// Add block in blockchain list
        addBlock(newBlock: newBlock)
        /// Result
        responder(TextResponse(200, block))
        print("Create new block")
        print("\(block)")
    }
}

while true {
    try server.loop()
}
