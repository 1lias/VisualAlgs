import Foundation

public class World {
    public var cells = [Cell]()
    public var width: Int
    public var height: Int
    public var cellSize: Int
    
    public init(width: Int, height: Int, cellSize: Int) {
        self.width = width
        self.height = height
        self.cellSize = cellSize
        fillGameOfLifeGrid(width: width, height: height, cellSize: cellSize)
    }
    
    public init(width: Int, height: Int, cellSize: Int, ruleCode: Int, randomness: Int) {
        self.width = width
        self.cellSize = cellSize
        self.height = height
        fillCAGrid(width: width, height: height, cellSize: cellSize, rand: randomness)
        updateCACells(rule: ruleCode)
    }
    
    func fillGameOfLifeGrid(width: Int, height: Int, cellSize: Int) {
        for x in 0..<width/cellSize {
            for y in 0..<height/cellSize {
                let randomState = arc4random_uniform(5)
                let cell = Cell(x: x, y: y, state: randomState == 0 ? .alive : .dead)
                cells.append(cell)
            }
        }
    }
    
    func fillCAGrid(width: Int, height: Int, cellSize: Int, rand: Int) {

        for y in 0..<height/cellSize {
            for x in 0..<width/cellSize {
                if y == 0 {
                    let randomState = arc4random_uniform(UInt32(rand))
                    let newCell = Cell(x: x, y: y, state: randomState == 0 ? .alive : .dead)
                    cells.append(newCell)
//                    if x == 50 {
//                        let newCell = Cell(x: x, y: y, state: .alive)
//                        cells.append(newCell)
//                    } else {
//                        let newCell = Cell(x: x, y: y, state: .dead)
//                        cells.append(newCell)
//                    }

                } else {
                    let newCell = Cell(x: x, y: y, state: .dead)
                    cells.append(newCell)
                }
            }
        }
    }
    
    func updateGameOfLifeCells() {
        var updatedCells = [Cell]()
        let liveCells = cells.filter { $0.state == .alive }
        
        for cell in cells {
            let livingNeighbors = liveCells.filter { $0.isNeighbour(to: cell) }
            switch livingNeighbors.count {
            case 2...3 where cell.state == .alive:
                updatedCells.append(cell)
                
            case 3 where cell.state == .dead:
                let liveCell = Cell(x: cell.x, y: cell.y, state: .alive)
                updatedCells.append(liveCell)
                
            default:
                let deadCell = Cell(x: cell.x, y: cell.y, state: .dead)
                updatedCells.append(deadCell)
            }
        }
        cells = updatedCells
    }
    
    func updateCACells(rule: Int) {
        var updatedCells = [Cell]()
        var horizontalCount = 0
        
        for cell in cells {
            if cell.y == 0 {
                updatedCells.append(cell)
                horizontalCount += 1
            } else {
                // need to find a way to calculate the input
                if cell.x == 0 {
                    var code = "0"
                    
                    if updatedCells[updatedCells.count - horizontalCount].state == .alive {
                        code.append("1")
                    } else {
                        code.append("0")
                    }
                    
                    if updatedCells[updatedCells.count - horizontalCount + 1].state == .alive {
                        code.append("1")
                    } else {
                        code.append("0")
                    }
                    
                    let newCell = Cell(x: cell.x, y: cell.y, state: ruleLogic(ruleNum: rule, input: code) ? .alive : .dead)
                    updatedCells.append(newCell)
                    
                } else if cell.x == width {
                    var code = ""
                    
                    if updatedCells[updatedCells.count - horizontalCount - 1].state == .alive {
                        code.append("1")
                    } else {
                        code.append("0")
                    }
                    
                    if updatedCells[updatedCells.count - horizontalCount].state == .alive {
                        code.append("1")
                    } else {
                        code.append("0")
                    }
                    
                    code.append("0")
                    
                    let newCell = Cell(x: cell.x, y: cell.y, state: ruleLogic(ruleNum: rule, input: code) ? .alive : .dead)
                    updatedCells.append(newCell)
                    
                } else {
                    var code = ""
                    
                    if updatedCells[updatedCells.count - horizontalCount - 1].state == .alive {
                        code.append("1")
                    } else {
                        code.append("0")
                    }
                    
                    if updatedCells[updatedCells.count - horizontalCount].state == .alive {
                        code.append("1")
                    } else {
                        code.append("0")
                    }
                    
                    if updatedCells[updatedCells.count - horizontalCount + 1].state == .alive {
                        code.append("1")
                    } else {
                        code.append("0")
                    }
                    if code == "010" {
                    }
                    let newCell = Cell(x: cell.x, y: cell.y, state: ruleLogic(ruleNum: rule, input: code) ? .alive : .dead)
                    updatedCells.append(newCell)
                    
//                    if updatedCells[updatedCells.count - horizontalCount].state == .alive {
//                        let newCell = Cell(x: cell.x, y: cell.y, state: .alive)
//                        updatedCells.append(newCell)
//                    } else {
//                        let newCell = Cell(x: cell.x, y: cell.y, state: .dead)
//                        updatedCells.append(newCell)
//                    }
                }
            }
        }
        cells = updatedCells
    }
    
    func ruleSetGenerator() -> [String] {
        var ruleSet: [String] = ["0","0","0","0","0","0","0","0"]
        
        for num in 0..<8 {
            ruleSet[7-num] = pad(string: String(num, radix: 2), toSize: 3)
        }
        return ruleSet
    }
    
    func ruleLogic(ruleNum: Int, input: String) -> Bool{
        let set = ruleSetGenerator()
        let binRuleNum = pad(string: String(ruleNum, radix: 2), toSize: 8)
        var index = 0
        for str in set {
            if input == str {
                return (Array(binRuleNum)[index] == "1" ? true : false)
            }
            index += 1
        }
        return false
    }
    
    
    func pad(string : String, toSize: Int) -> String {
        var padded = string
        for _ in 0..<(toSize - string.count) {
            padded = "0" + padded
        }
        return padded
    }
}
