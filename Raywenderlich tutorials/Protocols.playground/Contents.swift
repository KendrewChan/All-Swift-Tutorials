//: Playground - noun: a place where people can play

import UIKit

protocol Vehicle: CustomStringConvertible {
    var isRunning: Bool { get set} //protocol is a read-write property, hence 'get set' required
    mutating func start() //to be mutable means that its state can be modified after it is created
    mutating func turnOff()
}

struct SportsCar: Vehicle { //value type
    var isRunning: Bool = false
    var description: String {
        if isRunning {
            return "Sports car currently running"
        } else {
            return "Sports car turned off"
        }
    }
    
    mutating func start() { //mutable -> state can be modified since struct is of value type
        if isRunning {
            print("started")
        } else {
            isRunning = true
            print("vrooom")
        }
    }
    
    mutating func turnOff() {
        if isRunning {
            isRunning = false
            print("Crickets")
        } else {
            print("Engine already dead!")
        }
    }
}

class SemiTruck: Vehicle { //reference type
    var isRunning: Bool = false
    var description: String {
        if isRunning {
            return "Semi truck currently running"
        } else {
            return "Semi truck currently down"
        }
    }
    
    func start() { //immutable -> state cannot be modified since class is of reference type
        if isRunning {
            print("Engine already started")
        } else {
            isRunning = true
            print("Rumble")
        }
    }
    
    func turnOff() {
        if isRunning {
            isRunning = false
            print("... silence")
        } else {
            print("Engine already dead!")
        }
    }
    
    func blowAirHorn() {
        print("Bloop")
    }
}

var car1 = SportsCar()
var truck1 = SemiTruck()

truck1.blowAirHorn()

var vehicleArray: Array<Vehicle> = [car1, truck1]
for vehicle in vehicleArray {
    print("\(vehicle.description)")
}
