import UIKit

var str = "Hello, playground"

var optionalString: String? = "Hello"
print(optionalString == nil)
// Prints "false"

var optionalName: String? = nil
var greeting = "Hello!"
if let name = optionalName {
    greeting = "Hello, \(name)"
} else {
    greeting = "Hello!"
}

let nickName: String? = nil
let fullName: String = "John Appleseed"
let informalGreeting = "Hi \(nickName ?? fullName)"

let vegetable = "red pepper"
switch vegetable {
case "celery":
    print("Add some raisins and make ants on a log.")
case "cucumber", "watercress":
    print("That would make a good tea sandwich.")
case let x where x.hasSuffix("pepper"):
    print("Is it a spicy \(x)?")
default:
    print("Everything tastes good in soup.")
}
// Prints "Is it a spicy red pepper?"

let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largestNumber = 0
var largestKind: String?
let unknownKind = "unknown"
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largestNumber {
            largestNumber = number
            largestKind = kind
        }
    }
}
print("the largest number is \(largestNumber), which is a \(largestKind ?? unknownKind) number")
// Prints "25"

var n = 2
while n < 100 {
    n *= 2
}
print(n)
// Prints "128"

var m = 2
repeat {
    m *= 2
} while m < 100
print(m)
// Prints "128"

let a = 0..<4
let b = 0...4

// a == b  // Error: Binary operator '==' cannot be applied to operands of type 'Range<Int>' and 'ClosedRange<Int>'

var total = 0
for i in 0..<4 {
    total += i
}
print(total)
// Prints "6"

total = 0
for i in 0...4 {
    total += i
}
print(total)

let pi = 3.14159
var i = 0.0
while i <= 2 * pi {
    sin(i)
    i += 0.1
}

func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet(person: "Bob", day: "Tuesday")

func greet(_ person: String, on day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet("John", on: "Wednesday")

func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0

    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }

    return (min, max, sum)
}
let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
print(statistics.sum)
// Prints "120"
print(statistics.2)
// Prints "120"

func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()

func outer(_ a: Int) -> (aa: Int, bb: Int) {
    func inner(_ b: Int) -> Int {
        b
        a
        return b
    }
    return (aa: a, bb: inner(a + 1))
}
outer(12)

func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}
var numbers = [20, 19, 7, 12]
hasAnyMatches(list: numbers, condition: lessThanTen)

let h = numbers.map({ (number: Int) -> Int in
    if number % 2 == 1 {
        return 0
    }
    let result = 3 * number
    return result
})

numbers
h

let mappedNumbers = numbers.map({ number in 3 * number })
print(mappedNumbers)
// Prints "[60, 57, 21, 36]"

let sortedNumbers = numbers.sorted { $0 > $1 }
print(sortedNumbers)
// Prints "[20, 19, 12, 7]"

func lastArgIsClosere(_ a: Int, _ b: (Int) -> Bool) -> Int {
    if b(a) {
        return a
    }
    return -a
}
lastArgIsClosere(2) {
    $0 > 10
}
lastArgIsClosere(12) { (n: Int) -> Bool in
    return n > 10
}

class Shape {
    let isNotNil = true
    
    var numberOfSides = 0
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
    func sidesLessThen(_ sides: Int) -> Bool {
        return numberOfSides < sides
    }
}

var square = Shape(name: "Square")
if square.isNotNil {
    square.numberOfSides = 4
    square.simpleDescription()
    square.sidesLessThen(6)
}

class NamedShape {
    var numberOfSides: Int = 0
    var name: String

    init(name: String) {
        self.name = name
    }

    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

class Square: NamedShape {
    var sideLength: Double

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }

    func area() -> Double {
        return sideLength * sideLength
    }

    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}
let test = Square(sideLength: 5.2, name: "my test square")
test.area()
test.simpleDescription()

/*
Make another subclass of NamedShape called Circle that takes a radius and a name as arguments to its initializer. Implement an area() and a simpleDescription() method on the Circle class.
 */

class Circle: NamedShape {
    let pi = 3.1415926536
    var radius: Double
    
    init(radius: Double, name: String) {
        self.radius = radius
        super.init(name: name)
    }
    
    func area() -> Double {
        return pi * radius * radius
    }
    
    override func simpleDescription() -> String {
        return "A circle with radius of length \(radius)."
    }
}
let cir = Circle(radius: 1.414, name: "a test circle")
cir.area()
cir.simpleDescription()

class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }

    var perimeter: Double {
        get {
            return 3.0 * sideLength
        }
        set(nV) {
            sideLength = nV / 3.0
        }
    }

    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(triangle.perimeter)
// Prints "9.3"
triangle.perimeter = 9.9
print(triangle.sideLength)
// Prints "3.3000000000000003"

class TriangleAndSquare {
    var triangle: EquilateralTriangle {
        willSet {
            square.sideLength = newValue.sideLength
        }
    }
    var square: Square {
        willSet {
            triangle.sideLength = newValue.sideLength
        }
    }
    init(size: Double, name: String) {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
print(triangleAndSquare.square.sideLength)
// Prints "10.0"
print(triangleAndSquare.triangle.sideLength)
// Prints "10.0"
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
print(triangleAndSquare.triangle.sideLength)
// Prints "50.0"

var opt:String?
opt
opt = "aaa"

let optionalSquare: Square? = nil
// let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength

enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king

    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
    
    func BiggerThen(_ anotherRank: Rank) -> Bool {
        return self.rawValue > anotherRank.rawValue
    }
}
let ace = Rank.ace
let aceRawValue = ace.rawValue
Rank.king.simpleDescription()
Rank.queen.rawValue
Rank.five.BiggerThen(Rank.ace)

enum StringEnum: String {
    case a = "a", b = "b"
    case c = "c"
}

StringEnum.a

Rank(rawValue: 11)
StringEnum(rawValue: "b")
Rank(rawValue: 18)

enum Suit: Int {
    case spades, hearts, diamonds, clubs

    func simpleDescription() -> String {
        switch self {
        case .spades:
            return "spades"
        case .hearts:
            return "hearts"
        case .diamonds:
            return "diamonds"
        case .clubs:
            return "clubs"
        }
    }
    
    func color() -> String{
        switch self {
        case .clubs, .spades:
            return "black"
        case .diamonds, .hearts:
            return "red"
        }
    }
}
let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()

/*
 Add a color() method to Suit that returns “black” for spades and clubs, and returns “red” for hearts and diamonds.
 */
hearts.color()

enum ServerResponse {
    case result(String, String)
    case failure(String)
}

let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")

switch success {
case let .result(sunrise, sunset):
    print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
case let .failure(message):
    print("Failure...  \(message)")
}
// Prints "Sunrise is at 6:00 am and sunset is at 8:09 pm."

switch failure {
case let .result(sunrise, sunset):
    print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
case let .failure(message):
    print("Failure...  \(message)")
}

struct Card {
    var rank: Rank
    var suit: Suit
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}
let threeOfSpades = Card(rank: .three, suit: .spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()

struct CardStruct {
    var rank: Rank
    var suit: Suit
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}

class CardClass {
    var rank: Rank?
    var suit: Suit?
    func simpleDescription() -> String {
        return "The \(rank?.simpleDescription() ?? "") of \(suit?.simpleDescription() ?? "")"
    }
    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
}

func funcNeeds(cardStruct: CardStruct, cardClass: CardClass) {
    var cs = cardStruct
    var cc = cardClass
    
    cs.rank = .ace
    cc.rank = .ace
    
}

var s = CardStruct(rank: .five, suit: .clubs)
var c = CardClass(rank: .eight, suit: .diamonds)

funcNeeds(cardStruct: s, cardClass: c)

s
c

func getFullDeckOf() -> [Card] {
    var cards = [Card]()
    for ri in 1...13 {
        for si in 0..<4 {
            cards.append(Card(rank: Rank(rawValue: ri) ?? Rank.ace, suit: Suit(rawValue: si) ?? Suit.clubs))
        }
    }
    return cards
}
let aFullDeckOfCards = getFullDeckOf()
aFullDeckOfCards.count

protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    func adjust() {
        simpleDescription += "  Now 100% adjusted."
    }
}
var x = SimpleClass()
x.adjust()
let aDescription = x.simpleDescription

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    mutating func adjust() {
        simpleDescription += " (adjusted)"
    }
}
var y = SimpleStructure()
y.adjust()
let bDescription = y.simpleDescription

extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "The number \(self)"
    }
    mutating func adjust() {
        self += 42
    }
}
print(7.simpleDescription)
// Prints "The number 7"

protocol AbsoluteValueProtocol {
    var absoluteValue: Double { get }
}

extension Double: AbsoluteValueProtocol {
    var absoluteValue: Double {
        get {
            if self >= 0 {
                return self
            }
            return -self
        }
    }
}

print(666.33.absoluteValue)
print((-23333.33).absoluteValue)


// let 🕳️ = ExampleProtocol()
let protocolValue: ExampleProtocol = x
print(protocolValue.simpleDescription)
// Prints "A very simple class.  Now 100% adjusted."
// print(protocolValue.anotherProperty)  // Uncomment to see the error

enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}
let somewhatError = PrinterError.outOfPaper
somewhatError

func send(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrinterError.noToner
    }
    return "Job sent"
}

do {
    let printerResponse = try send(job: 1040, toPrinter: "Bi Sheng")
    print(printerResponse)
} catch {
    print(error)
}
// Prints "Job sent"

do {
    let printerResponse = try send(job: 1040, toPrinter: "Never Has Toner")
    print(printerResponse)
} catch {
    print(error)
}
// Prints "noToner"

do {
    let printerResponse = try send(job: 1440, toPrinter: "Never Has Toner")
    print(printerResponse)
} catch PrinterError.onFire {
    print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
    print("Printer error: \(printerError).")
} catch {
    print(error)
}
// Prints "Job sent"

let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")

var fridgeIsOpen = false
let fridgeContent = ["milk", "eggs", "leftovers"]

func fridgeContains(_ food: String) -> Bool {
    fridgeIsOpen = true
    defer {
        fridgeIsOpen = false
    }

    let result = fridgeContent.contains(food)
    return result
}
fridgeContains("banana")
print(fridgeIsOpen)
// Prints "false"

func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
        result.append(item)
    }
    return result
}
makeArray(repeating: "knock", numberOfTimes: 4)
makeArray(repeating: 666, numberOfTimes: 3)

// Reimplement the Swift standard library's optional type
enum OptionalValue<Wrapped> {
    case none
    case some(Wrapped)
}
var possibleInteger: OptionalValue<Int> = .none
possibleInteger = .some(100)

func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
    where T.Element: Equatable, T.Element == U.Element
{
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
    return false
}
anyCommonElements([1, 2, 3], [3])

var vvv = "df"
vvv.count
