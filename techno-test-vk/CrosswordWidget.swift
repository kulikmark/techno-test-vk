//
//  CrosswordWidget.swift
//  techno-test-vk
//
//  Created by Марк Кулик on 03.09.2024.
//

import UIKit
import SnapKit

class CrosswordWidget: UIViewController, UITextFieldDelegate {
    
    private var cellSize: CGFloat {
        return isPreviewMode ? view.frame.height / 8 / 10 : min(view.frame.width / 10, view.frame.height / 10)
    }

    private var verticalSpacing: CGFloat {
        return cellSize / 10
    }
    private var horizontalSpacing: CGFloat {
        return cellSize / 10
    }
    private var fontSize: CGFloat {
        return cellSize / 2
    }
    
    var correctGuesses: [String: Bool] = ["CAT": false, "APPLE": false, "EGG": false]
    var guessedWordsCount = 0
    
    var isPreviewMode = true
    
    private let crosswordContainer = UIView()
    private let cluesStackView = UIStackView()
    
    init(isPreviewMode: Bool) {
        self.isPreviewMode = isPreviewMode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        
        setupCrosswordContainer()
        setupClues()
        setupCrossword()
    }
    
    private func setupCrosswordContainer() {
        crosswordContainer.backgroundColor = .clear
        view.addSubview(crosswordContainer)
        
        crosswordContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.equalTo(cellSize * 6 + horizontalSpacing)
            make.height.equalTo(cellSize * 20 + verticalSpacing)
        }
    }
    
    private func setupClues() {
        cluesStackView.axis = .vertical
        cluesStackView.distribution = .equalSpacing
        cluesStackView.alignment = .leading
        cluesStackView.spacing = isPreviewMode ? 5 : 10
        cluesStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cluesStackView)
        
        let clues = [
            "1. An animal that says meow (3 letters).",
            "2. A fruit (5 letters).",
            "3. A common breakfast food (3 letters)."
        ]
        
        cluesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for clue in clues {
            let label = UILabel()
            label.text = clue
            label.font = UIFont.systemFont(ofSize: isPreviewMode ? 10 : 24)
            label.numberOfLines = 0
            cluesStackView.addArrangedSubview(label)
        }
        
        cluesStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(isPreviewMode ? -10 : -20)
        }
    }
    
    private func setupCrossword() {
        crosswordContainer.subviews.forEach { $0.removeFromSuperview() }
        
        createCell(in: crosswordContainer, position: CGPoint(x: 0, y: 0), tag: 1, letter: "C")
        createCell(in: crosswordContainer, position: CGPoint(x: 0, y: 1), tag: 2, letter: "A")
        createCell(in: crosswordContainer, position: CGPoint(x: 0, y: 2), tag: 3, letter: "T")
        
        createCell(in: crosswordContainer, position: CGPoint(x: 1, y: 1), tag: 4, letter: "P")
        createCell(in: crosswordContainer, position: CGPoint(x: 2, y: 1), tag: 5, letter: "P")
        createCell(in: crosswordContainer, position: CGPoint(x: 3, y: 1), tag: 6, letter: "L")
        createCell(in: crosswordContainer, position: CGPoint(x: 4, y: 1), tag: 7, letter: "E")
        
        createCell(in: crosswordContainer, position: CGPoint(x: 4, y: 2), tag: 9, letter: "G")
        createCell(in: crosswordContainer, position: CGPoint(x: 4, y: 3), tag: 10, letter: "G")
    }
    
    private func createCell(in container: UIView, position: CGPoint, tag: Int, letter: String) {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: fontSize)
        textField.borderStyle = .line
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.tag = tag
        textField.isUserInteractionEnabled = !isPreviewMode
        container.addSubview(textField)
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        textField.snp.makeConstraints { make in
            make.width.height.equalTo(cellSize)
            make.leading.equalTo(container.snp.leading).offset(position.x * (cellSize + horizontalSpacing))
            make.top.equalTo(container.snp.top).offset(position.y * (cellSize + verticalSpacing))
        }
        
        let numberLabel = UILabel()
        if tag == 1 {
            textField.text = "C"
            numberLabel.text = "\(tag)"
        } else if tag == 4 || tag == 9 {
            numberLabel.text = "\(tag)"
        }
        numberLabel.font = UIFont.systemFont(ofSize: 12)
        numberLabel.textAlignment = .center
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints { make in
            make.width.height.equalTo(cellSize / 3)
            make.leading.equalTo(container.snp.leading).offset(position.x * (cellSize + horizontalSpacing))
            make.top.equalTo(container.snp.top).offset(position.y * (cellSize + verticalSpacing))
        }
    }
    
    private func getLetter(for tag: Int) -> Character? {
        switch tag {
        case 1: return "C"
        case 2: return "A"
        case 3: return "T"
        case 4: return "P"
        case 5: return "P"
        case 6: return "L"
        case 7: return "E"
        case 8: return "E"
        case 9: return "G"
        case 10: return "G"
        default: return nil
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        
        let tag = textField.tag
        if let letter = getLetter(for: tag), text.uppercased() == String(letter) {
            textField.backgroundColor = .green
            textField.isUserInteractionEnabled = false
        } else {
            textField.backgroundColor = .red
        }
        
        updateGuessCount()
    }

    private func updateGuessCount() {
        let allTextFields = crosswordContainer.subviews.compactMap { $0 as? UITextField }
        
        let allFieldsFilled = allTextFields.allSatisfy { !$0.text!.isEmpty }
        
        if allFieldsFilled {
            var allGuessed = true
            
            var textFieldDict: [Int: String] = [:]
            allTextFields.forEach { textField in
                textFieldDict[textField.tag] = textField.text?.uppercased()
            }
            
            for (word, _) in correctGuesses {
                let wordTags = word.map { letter in
                    return crosswordContainer.subviews.compactMap { $0 as? UITextField }
                        .first { $0.text?.uppercased() == String(letter) }?.tag
                }.compactMap { $0 }
                
                let wordIsGuessed = wordTags.enumerated().allSatisfy { index, tag in
                    let letter = word[word.index(word.startIndex, offsetBy: index)]
                    return textFieldDict[tag] == String(letter).uppercased()
                }
                
                if !wordIsGuessed {
                    allGuessed = false
                    break
                }
            }
            
            if allGuessed {
                guessedWordsCount = correctGuesses.count
                DispatchQueue.main.async { [weak self] in
                    let alert = UIAlertController(title: "Поздравляем!", message: "Вы отгадали все слова!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
