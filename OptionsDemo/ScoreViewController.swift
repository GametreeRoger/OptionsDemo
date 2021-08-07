//
//  ScoreViewController.swift
//  ScoreViewController
//
//  Created by 張又壬 on 2021/8/7.
//

import UIKit

protocol PlayagainDelegate {
    func playAgain()
}

class ScoreViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    var score: Int
    var delegate: PlayagainDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scoreLabel.text = "\(score) 分"
    }
    
    init?(coder: NSCoder, score: Int, delegate: PlayagainDelegate) {
        self.score = score
        self.delegate = delegate
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate.playAgain()
    }

    @IBAction func playAgain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
