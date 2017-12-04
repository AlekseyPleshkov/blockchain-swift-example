//
//  BlockchainBlock.swift
//  blockchain-swift-examplePackageDescription
//
//  Created by Aleksey Pleshkov on 01.12.2017.
//

import Foundation

public struct BlockchainBlock: Encodable {
    public let index: Int
    public let prevHash: String
    public let timestamp: Double
    public let data: String
    public let hash: String
    

    init(index: Int, prevHash: String, timestamp: Double, data: String, hash: String) {
        self.index = index
        self.prevHash = prevHash
        self.timestamp = timestamp
        self.data = data
        self.hash = hash
    }
}
