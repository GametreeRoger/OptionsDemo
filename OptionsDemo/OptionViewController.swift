//
//  ViewController.swift
//  OptionsDemo
//
//  Created by 張又壬 on 2021/8/7.
//

import UIKit

class OptionViewController: UIViewController {

    @IBOutlet weak var associateLabel: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var optionButtons: [UIButton]!
    
    let SEGUE_ID = "showScore"
    let FILE_NAME = "Questions"
    let CORRECT_TITLE = "正確"
    let CORRECT_MESSAGE = "你答對了！！"
    let WRONG_TITLE = "錯誤"
    let WRONG_MESSAGE = "你答錯了...."
    let MAX_QUESTIONS = 10
    let PER_QUESTION_SCORE = 10
    
    var questions: [Question]!
    var currentQuestions: [Question]!
    var currentQuestion: Question {
        currentQuestions[index]
    }
    var index: Int = 0 {
        didSet {
            updateUI()
        }
    }
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questions = loadQuestions()
        createQuestions()
        index = 0
        score = 0
    }
    
    func loadQuestions() -> [Question] {
        guard let data = NSDataAsset(name: FILE_NAME)?.data else {
            print("Get file fail")
            return [Question]()
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Question].self, from: data)
        } catch {
            fatalError("error: \(error)")
        }
    }
    
    func createQuestions() {
        currentQuestions = Array(questions.shuffled().prefix(MAX_QUESTIONS))
    }
    
    func updateUI() {
        if index >= currentQuestions.count {
            return
        }
        
        associateLabel.text = "關聯： \(currentQuestion.associate)"
        questionLabel.text = "\(index + 1). 題目： \(currentQuestion.question)"
        let options = currentQuestion.options.shuffled()
        for (i, _) in optionButtons.enumerated() {
            optionButtons[i].setTitle(options[i], for: .normal)
        }
    }
    
    func showAlert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.index += 1
            if self.index == self.currentQuestions.count {
                self.performSegue(withIdentifier: self.SEGUE_ID, sender: nil)
            }
        }
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func selectOption(_ sender: UIButton) {
        if let answer = sender.titleLabel?.text {
            if answer == currentQuestion.correctAnswer {
                score += PER_QUESTION_SCORE
                showAlert(title: CORRECT_TITLE, message: CORRECT_MESSAGE)
            } else {
                showAlert(title: WRONG_TITLE, message: WRONG_MESSAGE)
            }
        }
    }
    
    @IBSegueAction func sendScore(_ coder: NSCoder) -> ScoreViewController? {
        let controller = ScoreViewController(coder: coder, score: score, delegate: self)
        if let sheetController = controller?.sheetPresentationController {
            sheetController.detents = [.medium()]
        }
        return controller
    }
}

extension OptionViewController: PlayagainDelegate {
    func playAgain() {
        createQuestions()
        index = 0
        score = 0
    }
}
