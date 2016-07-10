//
//  ViewController.swift
//  swift-snake
//
//  Created by Weihang Lo on 7/4/16.
//  Copyright © 2016 Weihang Lo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var snake: SnakeModel?
    private var fruit: Point?
    private let snakeView = SnakeView()
    private var timer: NSTimer?
    
    private let newButton = UIButton(type: .Custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        
        
        snake = SnakeModel(worldSize: WorldSize(width: 20, height: 20))
        snakeView.delegate = self
        snakeView.backgroundColor = UIColor(red: 1.0, green: 0.94, blue: 0.75, alpha: 1.0)
        
        view.addSubview(snakeView)
        
        let width = view.bounds.width
        let height = view.bounds.height
        newButton.setTitle("New Game", forState: .Normal)
        newButton.layer.cornerRadius = 5.0
        newButton.backgroundColor = UIColor(red: 0.3, green: 0.8, blue: 0.45, alpha: 1.0)
        newButton.autoresizingMask = [.FlexibleTopMargin, .FlexibleBottomMargin, .FlexibleLeftMargin, .FlexibleRightMargin]
        newButton.frame = CGRect(x: (width - 100) / 2, y: (height - 40) / 2, width: 100, height: 40)
        newButton.addTarget(self, action: #selector(buttonAction(_:)), forControlEvents: .TouchUpInside)
        newButton.layer.shadowPath = UIBezierPath(rect: newButton.bounds).CGPath
        newButton.layer.shadowColor = UIColor.blackColor().CGColor
        newButton.layer.shadowOpacity = 0.5
        newButton.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        view.addSubview(newButton)
        
        
        let directionArray: [UISwipeGestureRecognizerDirection] = [.Up, .Down, .Left, .Right]
        directionArray.forEach { direction in
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
            swipe.direction = direction
            view.addGestureRecognizer(swipe)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutSnakeView()
    }
    
    private func createFruit() {
        guard let snake = snake else { return }
        
        let width = UInt32(snake.worldSize.width)
        let height = UInt32(snake.worldSize.height)
        
        
        while true {
            var isBody = false
            let x = Int(arc4random_uniform(width))
            let y = Int(arc4random_uniform(height))
            
            for point in snake.body {
                if point.x == x && point.y == y {
                    isBody = true
                    break
                }
            }
            
            if !isBody {
                fruit = Point(x: x, y: y)
                break
            }
        }
    }
    
    private func layoutSnakeView() {
        guard let snake = snake else { return }
        
        let width = CGFloat(snake.worldSize.width)
        let height = CGFloat(snake.worldSize.height)
        
        var size = view.bounds.size
        var origin = CGPoint.zero
        
        if size.width / size.height >= width / height {
            size.width = size.height * width / height
            origin.x = (view.bounds.size.width - size.width) / 2.0
        } else {
            size.height = size.width * height / width
            origin.y = (view.bounds.size.height - size.height) / 2.0
        }
        
        snakeView.frame = CGRect(origin: origin, size: size)
    }
    
    @objc private func buttonAction(sender: AnyObject) {
        
        (sender as? UIButton)?.enabled = false
        
        UIView.animateWithDuration(0.3, animations: {
            self.newButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.newButton.alpha = 0.5
        }) { _ in
            self.newButton.hidden = true
            self.snake = SnakeModel(worldSize: WorldSize(width: 20, height: 20))
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(self.timerAction(_:)) , userInfo: nil, repeats: true)
            self.snakeView.setNeedsDisplay()
            self.timer?.fire()
            self.createFruit()
        }
        
    }
    
    @objc private func timerAction(sender: AnyObject) {
        guard let fruit = fruit else { return }
        guard let snake = snake else { return }
        
        snake.moveHead()
        if snake.head.x == fruit.x && snake.head.y == fruit.y {
            snake.extendBody()
            createFruit()
        }
        
        if snake.bumpIntoBorder() || snake.bumpIntoSelf() {
            timer?.invalidate()
            timer = nil
            
            snake.extendBody()
            
            newButton.hidden = false
            newButton.enabled = true
            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 8.0, options: .BeginFromCurrentState, animations: {
                self.newButton.transform = CGAffineTransformMakeScale(1, 1)
                self.newButton.alpha = 1.0
            }, completion: nil)
        }
        snakeView.setNeedsDisplay()
    }
    
    @objc private func swipeAction(sender: UIGestureRecognizer) {
        guard let gesture = sender as? UISwipeGestureRecognizer else { return }
        
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.Up:
            snake?.direction = .Down
        case UISwipeGestureRecognizerDirection.Down:
            snake?.direction = .Up
        case UISwipeGestureRecognizerDirection.Left:
            snake?.direction = .Left
        case UISwipeGestureRecognizerDirection.Right:
            snake?.direction = .Right
            
        default: break
        }
    }
}

extension ViewController: SnakeViewDelegate {
    func snakeModelForSnakeView(view: SnakeView) -> SnakeModel {
        return snake!
    }
    
    func pointOfFruitForSnakeView(view: SnakeView) -> Point? {
        return fruit
    }
}

