//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//loops
var salaries = [0.0, 1.0, 2.0, 3.0]
for i in 0..<salaries.count {
    salaries[i] = salaries[i] + (salaries[i] * 0.10)
}

for salary in salaries {
    print("Salary: \(salary)")
}

/////////////////////////////////////////////////////////////////
//dictionaries or hash tables
    //arrays: 0 - eggs, 1 - milk, 2- flour
    //dictionary: YYZ - eggs, DYB - milk, LHR - flour (Keys - Values)

var NumbersBecomeWorded = [Int: String]()
NumbersBecomeWorded[3] = "three"
NumbersBecomeWorded[44] = "forty four"
NumbersBecomeWorded = [:] //clears all the keys

var airports: [String: String] = ["YYZ": "Toronto Pearson", "LAX": "Los Angeles International"]
print("The airports dictionary has : \(airports.count) items")
if airports.isEmpty {
    print("The airports dictionary is empty!")
}
airports["LHR"] = "London" //adding new key and value
airports["LHR"] = "London Heathrow" //replaces previous value
airports["LHR"] = nil //destroys & deletes the dictionary

for (airportCode, airportName) in airports { //key - airportCode, value - airportName
    print("\(airportCode): \(airportName)")
}
for key in airports.keys {
    print("Key: " + key)
}
for val in airports.values {
    print("Value: \(val)")
}

/////////////////////////////////////////////////////////////////
var lotteryWinnings: Int? //optional, not sure if there's a value
if lotteryWinnings != nil { //if theres a value in lotteryWinnings
    print(lotteryWinnings) //exclamation to unwrap it.
}
if let winnings = lotteryWinnings { //same as on top
    print(winnings)
}

class Car {
    var model: String?
    
}

var vehicle: Car?

/* if let v = vehicle { //pertaining to optionals for vehicle
    if let m = v.model { //optionals for for model of vehicles
        print(m)
    }
} */
vehicle = Car()
vehicle?.model = "Bronco"
if let v = vehicle, let m = v.model {
    print(m)
}
var cars: [Car]?
cars = [Car]()
if let carArr = cars where carrArr.count > 0 {
    //only execute if not nil and if more than 0
}
class Person {
    var _age: Int! //if you guarantee a value
    var age: Int {
        if _age == nil { //safety measures when doing forceunwrap
            _age = 15
        }
        return _age
    }
    // var age = 0 //initialising value prevents crashes too
    
    func setAge(newAge: Int) {
        self.age = newAge
    }
}

var jack = Person()

class Dog {
    var species : String
    
    init(someSpecies: String) {
        self.species = someSpecies
    }
}

var lab = Dog(someSpecies: "Black Lab")
print(lab.species)

//////////////////////////////////////////////////////////////////////