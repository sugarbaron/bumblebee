# lightweight and useful toolkit with beautiful syntax!

### * structured concurrency tools:

``` swift
// queue over async/await structured concurrency:
let background: Async.Fifo = .init()
background.enqueue { [weak self] in await self?.parseNext() }

// main actor control:
onMain       { [weak self] in await self?.controlUi() }
inBackground { [weak self] in await self?.heavyWork() }

// pause:
await idle(seconds)
```

### * expressive and laconic access and transformations:

``` swift
print("0x\(data.hexString))" // prints: 0xdeadbeef
let number: Int = double.int // Double -> Int
let random: Int = UUID().int // random int
Bundle.version.build         // 1.5.0
Bundle.version.number        // 208805231431
array[safe: index]           // safe access to avoid out of range

let list: [User] = [...]
let users: [Int : User] = list.transform(key: \.id)
```
