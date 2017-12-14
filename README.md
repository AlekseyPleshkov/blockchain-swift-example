# Blockchain swift example

A blockchain example

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
curl http://localhost:8080/blocks
```

Get list of transactions

```
curl http://localhost:8080/transactions
```

Mine block

```
curl http://localhost:8080/mine
```

Create transaction

```
curl http://localhost:8080/transaction?actor=NAME&target=NAME&count=NUMBER
```

Validate blocks in blockchain

```
curl http://localhost:8080/validateBlockchain
```
