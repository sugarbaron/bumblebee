# lightweight and useful toolkit with beautiful syntax!

### * expressive and laconic access and transformations:

```
print("0x\(data.hexString)"  // prints: 0xdeadbeef
let number: Int = double.int // Double -> Int
let random: Int = UUID().int // random int
Bundle.version.build         // 1.5.0
Bundle.version.number        // 208805231431
array[safe: index]           // safe access to avoid out of range

let list: [User] = [...]
let users: [Int : User] = list.transform(key: \.id)
```
