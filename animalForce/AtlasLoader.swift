//
//  AtlasLoader.swift
//  animaForce
//
//  Created by George Kravas on 14/01/16.
//  Copyright © 2016 George Kravas. All rights reserved.
//

import Foundation
import SpriteKit
import RxSwift

open class AtlasLoader {
    
    //Shared instance for the singleton patern
    static let sharedInstance = AtlasLoader()
    
    fileprivate var loadedAtlases = [String: SKTextureAtlas]();
    
    init() {
        
    }
    
    fileprivate func loadAtlas(_ atlasName:String) -> Observable<SKTextureAtlas> {
        if let cached = loadedAtlases[atlasName] {
            return Observable.just(cached)
        }
        return Observable.create { (observer: AnyObserver<SKTextureAtlas>) -> Disposable in
            SKTextureAtlas.preloadTextureAtlasesNamed([atlasName], withCompletionHandler: {(error, atlases) in
                if let err = error {
                    observer.onError(err)
                } else {
                    self.loadedAtlases[atlasName] = atlases[0]
                    observer.onNext(atlases[0])
                    observer.onCompleted()
                }
            });
            return Disposables.create()
        }
    }
    
    fileprivate func sliceTexture(_ texture:SKTexture, rows:Int, collumns: Int, data:inout [String: [SKTexture]]) {
        let tileWidth = texture.size().width / CGFloat(collumns);
        let tileHeight = texture.size().height / CGFloat(rows);
        
        for x in 0..<collumns {
            for y in 0..<rows {
                let key = String(format: "%d_%d", x, y)
                let rect = CGRect(x: CGFloat(x) * tileWidth / texture.size().width,
                                 y: CGFloat(y) * tileHeight / texture.size().height,
                                 width: tileWidth / texture.size().width,
                                 height: tileHeight / texture.size().height)
                
                if data[key] == nil {
                    data[key] = [SKTexture]()
                }
                data[key]?.append(SKTexture(rect: rect, in: texture));
            }
        }
    }
    
    fileprivate func createTiles(_ data:[String : [SKTexture]], rows:Int, collumns: Int) -> Observable<[Tile]> {
        var result = [Tile]();
        for x in 0..<collumns {
            for y in 0..<rows {
                let key = String(format: "%d_%d", x, y)
                let initialPosition = CGPoint(x: x, y: y)
                let textures = data[key]
                result.append(Tile(textures: textures!, initialPosition: initialPosition))
            }
        }
        return Observable.just(result)
    }
    
    
    open func createAnimatedTiles( _ atlasName:String, rows:Int, collumns: Int) -> Observable<[Tile]> {
        return self.loadAtlas(atlasName)
            .flatMap { (atlas:SKTextureAtlas) -> Observable<[String: [SKTexture]]> in
                var result = [String: [SKTexture]]();
                atlas.textureNames.forEach({ (textureName: String) -> () in
                    self.sliceTexture(atlas.textureNamed(textureName), rows: rows, collumns: collumns, data: &result)
                })
                return Observable.just(result);
            }
            .flatMap { (data:[String : [SKTexture]]) -> Observable<[Tile]> in
                return self.createTiles(data, rows: rows, collumns: collumns)
            }
    }

}
