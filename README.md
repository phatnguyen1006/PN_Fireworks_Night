# PN_Fireworks_Night

## colorBlendFactor: A floating-point value that describes how the color is blended with the sprite’s texture.
### colorBlendFactor value to 0. That will disable the color blending entirely, making the firework white.

## reversed(): Return reverse order.
There is one curious quirk here, and it's down to how you remove items from an array. 
When removing items, we're going to loop through the array backwards rather than forwards. 
The reason for is that array items move down when you remove an item, so if you have 1, 2, 3, 4 and remove 3 then 4 moves down to become 3. 
If you're counting forwards, this is a problem because you just checked three and want to move on, but there's now a new 3 and possibly no longer a 4! 
If you're counting backwards, you just move on to 2.

## MARK: - for case let comes in: it lets us attempts some work (typecasting to SKSpriteNode in this case), and run the loop body only for items that were successfully typecast.
## MARK: - The let node part creates a new constant called node, the case…as SKSpriteNode part means “if we can typecast this item as a sprite node, and of course the for loop is the loop itself.

## motionBegans
This is easy enough to do because iOS will automatically call a method called motionBegan() on our game when the device is shaken. Well, it's a little more complicated than that – what actually happens is that the method gets called in GameViewController.swift, which is the UIViewController that hosts our SpriteKit game scene.
```swift
// inside GameViewController.swift
override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    guard let skView = view as? SKView else { return }
    guard let gameScene = skView.scene as? GameScene else { return }
    gameScene.explodeFireworks()
}
```
