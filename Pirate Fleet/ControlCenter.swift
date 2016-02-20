//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    

// TODO: Add the computed property, cells.
    var cells: [GridLocation] {
        get {
            // Hint: These two constants will come in handy
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
            
//            // Hint: The cells getter should return an array of GridLocations.
            
            var localCells = [GridLocation]()
            
            for x in start.x...end.x {
                for y in start.y...end.y {
                    localCells.append(GridLocation(x: x, y: y))
                }
            }
            return localCells
        }
        
    }
    
    var hitTracker: HitTracker
    
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    
    var sunk: Bool {
        
        var counterForHits = 0
        
        for gridLocation in hitTracker.cellsHit.keys {
            if hitTracker.cellsHit[gridLocation] == true {
                counterForHits++
            }
        }
        
        if counterForHits == hitTracker.cellsHit.count {
            return true
        } else {
            return false
        }
    }

// TODO: Add custom initializers
    
    init(length: Int, location: GridLocation, isVertical: Bool) {
        self.length = length
        self.location = GridLocation(x: location.x, y: location.y)
        self.isVertical = isVertical
        self.isWooden = true
        self.hitTracker = HitTracker()
    }
    
    init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool, hitTracker: HitTracker) {
        self.length = length
        self.location = GridLocation(x: location.x, y: location.y)
        self.isVertical = isVertical
        self.isWooden = isWooden
        self.hitTracker = HitTracker()
    }
    
}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    
    var location: GridLocation {get}
    var guaranteesHit: Bool {get set}
    var penaltyText: String {get}
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
    let location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String
    
    init(location: GridLocation, penaltyText: String) {
        self.location = GridLocation(x: location.x, y: location.y)
        self.penaltyText = penaltyText
        self.guaranteesHit = true
    }
    
    init(location: GridLocation, penaltyText: String, guaranteesHit: Bool) {
        self.location = GridLocation(x: location.x, y: location.y)
        self.penaltyText = penaltyText
        self.guaranteesHit = guaranteesHit
    }
}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    let location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {
        
        var smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: false)
        
        smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: false, isWooden: false, hitTracker: HitTracker())
        human.addShipToGrid(smallShip)
        print(smallShip.cells)
        
        var mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false)
        
        mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false, isWooden: false, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip1)
        print(mediumShip1.cells)
        
        var mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false)
        mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false, isWooden: true, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip2)
        
        var largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true)
        largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, isWooden: false, hitTracker: HitTracker())
        human.addShipToGrid(largeShip)
        
        var xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true)
        xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true, isWooden: false, hitTracker: HitTracker())
        human.addShipToGrid(xLargeShip)
        
        var mine1 = Mine(location: GridLocation(x: 6, y: 0), penaltyText: "That is not a Sea Monster at least.")
        mine1 = Mine(location: GridLocation(x: 6, y: 0), penaltyText: "That is not a Sea Monster at least.", guaranteesHit: true)
        human.addMineToGrid(mine1)
        
        var mine2 = Mine(location: GridLocation(x: 3, y: 3), penaltyText: "That is not a Sea Monster at least.")
        mine2 = Mine(location: GridLocation(x: 3, y: 3), penaltyText: "That is not a Sea Monster at least.", guaranteesHit: false)
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6), guaranteesHit: true, penaltyText: "Now that is what we call a Sea Monster!")
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2), guaranteesHit: true, penaltyText: "Now that is what we call a Sea Monster!")
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}