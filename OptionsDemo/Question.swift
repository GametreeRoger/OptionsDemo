//
//  Question.swift
//  Question
//
//  Created by 張又壬 on 2021/8/7.
//

import Foundation

struct Question: Codable {
    let associate: String
    let question: String
    let options: [String]
    let answer: Int
    var correctAnswer: String {
        options[answer]
    }
}
