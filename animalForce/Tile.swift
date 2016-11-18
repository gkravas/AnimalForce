//
//  Tile.swift
//  animalForce
//
//  Created by George Kravas on 14/01/16.
//  Copyright © 2016 George Kravas. All rights reserved.
//

import Foundation
import SpriteKit

open class Tile: SKSpriteNode {
    
    fileprivate var animationTextures = [SKTexture]()
    open var initialPosition = CGPoint(x: 0,y: 0)
    
    public init(textures: [SKTexture], initialPosition: CGPoint) {
        super.init(texture: textures[0], color: UIColor.white, size: textures[0].size())
        self.animationTextures = textures
        self.initialPosition = initialPosition
        self.anchorPoint = CGPoint.zero
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func animate() {
        run(SKAction.repeatForever(
            SKAction.animate(with: animationTextures,
                timePerFrame: 0.22,
                resize: false,
                restore: true)),
                withKey:"animate")
    }
}
