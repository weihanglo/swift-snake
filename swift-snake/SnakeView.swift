//
//  SnakeView.swift
//  swift-snake
//
//  Created by Weihang Lo on 7/8/16.
//  Copyright © 2016 Weihang Lo. All rights reserved.
//

import UIKit

let π = Double.pi

protocol SnakeViewDelegate {
    func snakeModelForSnakeView(_ view: SnakeView) -> SnakeModel
    func pointOfFruitForSnakeView(_ view:SnakeView) -> Point?
}

@IBDesignable
class SnakeView: UIView {
    
    var delegate: SnakeViewDelegate?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let snake = delegate?.snakeModelForSnakeView(self) else { return }
        
        
        let worldSize = snake.worldSize
        
        let w = Int(Float(rect.width) / Float(worldSize.width))
        let h = Int(Float(rect.height) / Float(worldSize.height))
        
        UIColor.green.set()
        for point in snake.body {
            let rect = CGRect(x: point.x * w, y: point.y * h, width: w, height: h)
            UIBezierPath(rect: rect).fill()
        }
        
        
        if let fruit = delegate?.pointOfFruitForSnakeView(self) {
            UIColor.red.set()
            let rect = CGRect(x: fruit.x * w, y: fruit.y * h, width: w, height: h)
            UIBezierPath(ovalIn: rect).fill()
        }
    }
    
}
