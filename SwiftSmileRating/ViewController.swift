//
//  ViewController.swift
//  SwiftSmileRating
//
//  Created by 默司 on 2016/8/3.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SwiftSmileRatingViewDelegate {
    
    @IBOutlet weak var smileView: SwiftSmileRatingView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        smileView.delegate = self
        scoreLabel.text = "\(smileView.currentScore)"
    }
    
    func smileRatingView(view: SwiftSmileRatingView, didScoreChange score: Int) {
        scoreLabel.text = "\(score)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

