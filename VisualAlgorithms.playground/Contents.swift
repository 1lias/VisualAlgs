//: # Visual Algorithms
//: ### A tool to explore the endless world that lies between Technology and Art
/*:
 I have made you a little tool that lets you create algorithmic art based on simple rules that are chosen by you. I am using a well known collection of rules that use Cellular Automata to generate graphical elements on the screen.
 
 Let's start by running the code with the already set parameters.
 
 * Just press the **Run My Code** button to run the playground and see what happens!

 There you have a beautiful art piece made by the algorithm just for you!
 
 In this playground there are 256 possible rules that can be used in order to color the pixels. Each pixel is being colored based on the state of its neighbouring pixels above. The algorithm lets pixels have only two states - alive or dead.
 
 * Change the number bellow to a number between 0 and 255 so you can see how different the drawings can be. (Try number 22 it is really nice)
 
 **Hint:** You can tap on the graphic and make it change colors - there is truly an infinite amount of drawings you can make!
 */
var rule = /*#-editable-code*/105/*#-end-editable-code*/
/*:
### How does it work?
 
The top row of pixels is being generated with a random number of alive and dead pixels. After that, that row is used in combination with the rules of the Cellular Automata in order to generate the final image. The algorithm then goes line by line in order to decide if a pixel will be alive or dead.
 
 The patterns you see can be found many times in everyday life. You see them in art made a thousand years ago but also in nature like the patterns of the shells of some water creatures or the way tree branches grow.
 
 Changing the rule number gives you a lot of variability in the drawings. Additionally, there are two more variables that can help you get to even cooler outputs!
 
 * Try changing the values in the variables bellow:
 
 _randomnessRatio_: lets you choose the ratio of alive pixels in the first row of the image. This drastically changes the final output as the whole image is generated based on what is the state of the pixels on the first row!
 */
var randomnessRatio = /*#-editable-code*/30/*#-end-editable-code*/
var pixelSize = /*#-editable-code*/2/*#-end-editable-code*/

//: Change the bellow to true if you want to see the colors change on their own!
var partyMode = /*#-editable-code*/false/*#-end-editable-code*/

//: As Easter is not too far away, here is an Easter Egg for you. If you turn the variable to true you can see something that is called The Game of Life. It is also a Cellular Automaton that lets the pixels live or die based on simple rules. You can observe the system be alive until it reaches equilibrium.
var easterEgg = /*#-editable-code*/false/*#-end-editable-code*/

//: This was your short but beautiful introduction to the infinite world of **Computational** **Art**. Do not be afraid to keep playing with the numbers, you may discover something really beautiful. Thank you for your time!

//#-hidden-code
import UIKit
import PlaygroundSupport

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if easterEgg {
            let draw = WorldView(frame: self.view.bounds, cellSize: 6)
            view.addSubview(draw)
            draw.autoRun()
        } else {
            let draw = WorldView(frame: self.view.bounds, cellSize: pixelSize, ruleCode: rule, randomGen: randomnessRatio)
            view.addSubview(draw)
            if partyMode {
                draw.autoRun()
            }
        }
    }
}


PlaygroundPage.current.liveView = ViewController()
//#-end-hidden-code
