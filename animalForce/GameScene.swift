//
//  GameScene.swift
//  animalForce
//
//  Created by George Kravas on 14/01/16.
//  Copyright (c) 2016 George Kravas. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        let offset = CGFloat(0);
        let scale = CGFloat(2)
        AtlasLoader.sharedInstance
            .createAnimatedTiles("level_2", rows: 4, collumns: 3)
            .subscribe(
                onNext: { (tiles:[Tile]) -> Void in
                    tiles.forEach({ (tile:Tile) -> () in
                        tile.position = CGPoint(x:offset + scale * tile.initialPosition.x * 108, y:offset + scale * tile.initialPosition.y * 108)
                        tile.xScale = scale
                        tile.yScale = scale
                        self.addChild(tile)
                        tile.animate()
                    })
                }, onError: { (error) -> Void in
                    // ERROR!
                }, onCompleted: { () -> Void in
                    // There are no more signals
                }) { () -> Void in
                    // We disposed this subscription
                }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        return;
        for touch in touches {
            let location = touch.location(in: self)

            let texture = SKTexture(imageNamed: "level_2_0")
            let rect = CGRect(x: 80, y: 80, width: 80, height: 143)
            let sprite = SKSpriteNode(texture: SKTexture(rect: rect, in: texture), color: UIColor.white, size: CGSize(width: 200, height: 200))
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            print(location)
            let action = SKAction.rotate(byAngle: CGFloat(M_PI), duration:1)
            
            sprite.run(SKAction.repeatForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
