import Foundation
import UIKit

extension UIColor {
    func interpolateRGBColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor? {
        let f = min(max(0, fraction), 1)
        
        
        
        guard let c1 = self.cgColor.components, let c2 = end.cgColor.components else { return nil }
        
        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}


public class WorldView: UIView {
    var cellSize: Int = 8
    var world: World = World(width: 768, height: 1024, cellSize: 8)
    
    var colors = [UIColor]()
    var ruleCode = 22
    var gameOfLife = false
    
    
    
    public convenience init(frame: CGRect, cellSize: Int) {
        self.init(frame: frame)
        
        self.gameOfLife = true
        
        self.colors =  generateColors(number: 4)
        
        self.cellSize = cellSize
        self.world = World(width: Int(bounds.width), height: Int(bounds.height), cellSize: self.cellSize)
    }
    
    public convenience init(frame: CGRect, cellSize: Int, ruleCode: Int, randomGen: Int) {
        self.init(frame: frame)
        
        self.colors =  generateColors(number: 4)
        
        self.cellSize = cellSize
        self.ruleCode = ruleCode
        self.world = World(width: Int(bounds.width), height: Int(bounds.height), cellSize: self.cellSize, ruleCode: ruleCode , randomness: randomGen)
    }
    
    public convenience init() {
        let frame = CGRect(x: 0, y: 0, width: 768, height: 1024)
        self.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        for cell in world.cells {
            
            let rect = CGRect(x: cell.x * cellSize, y: cell.y * cellSize, width: cellSize, height: cellSize)
            context?.addRect(rect)
            if cell.state == .alive {
                context?.setFillColor(colors[0].interpolateRGBColorTo(colors[1], fraction: CGFloat(Float(cell.y) / (Float(world.height) / Float(world.cellSize))))!.cgColor)
            } else {
                context?.setFillColor(colors[2].interpolateRGBColorTo(colors[3], fraction: CGFloat(Float(cell.y) / (Float(world.height) / Float(world.cellSize))))!.cgColor)
            }
            context?.fill(rect)
        }
        
        if !gameOfLife {
            
            self.colors =  generateColors(number: 4)
        }
        context?.restoreGState()
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOfLife {
            world.updateGameOfLifeCells()
        } else {
            world.updateCACells(rule: ruleCode)
        }
        setNeedsDisplay()
    }
    
    public func autoRun() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.gameOfLife {
                self.world.updateGameOfLifeCells()
            } else {
                self.world.updateCACells(rule: self.ruleCode)
            }
            self.setNeedsDisplay()
            self.autoRun()
        }
    }
    
    func generateColors(number: Int) -> [UIColor]{
        var array = [UIColor]()
        for _ in 0..<number {
            array.append(UIColor(red: CGFloat(Float.random(in: 0...1)), green: CGFloat(Float.random(in: 0...1)), blue: CGFloat(Float.random(in: 0...1)), alpha: 1))
        }
        return array
    }
}


