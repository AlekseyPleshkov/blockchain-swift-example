# Blockchain swift example

A blockchain example in 100 lines of code

## What is blockchain

Blockchain is a distributed database that maintains a continuously-growing list of records called blocks secured from tampering and revision.

## Quick start

Clone repository and install dependencies

```sh
git clone git@github.com:AlekseyPleshkov/blockchain-swift-example.git
cd blockchain-swift-example
swift package update
swift build
swift run
```

Use in Xcode

```sh
swift package generate-xcodeproj
open blockchain-swift-example.xcodeproj
```

## Use

Get list of blockchain blocks

```
curl http://localhost:8080/getBlocks
```
Add block to list of blockchain

```
curl http://localhost:8080/addBlock?data=testData
```

