//
//  TicTacToeWidget.swift
//  techno-test-vk
//
//  Created by Марк Кулик on 03.09.2024.
//

import UIKit
import SnapKit

class TicTacToeWidget: UIViewController {
    private let isPreviewMode: Bool
    private var currentPlayer: String = "X"
    private var gameBoard: [[UIButton?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    
    private var titleLabel: UILabel!
    
    init(isPreviewMode: Bool) {
        self.isPreviewMode = isPreviewMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        setupTitleLabel()
        setupGrid()
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "TicTacToe"
        
        // Изменение размера шрифта в зависимости от режима просмотра
        let fontSize: CGFloat = isPreviewMode ? 12 : 24
        titleLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Задание отступа сверху в зависимости от режима
        let topOffset: CGFloat = isPreviewMode ? 5 : 20
        
        // Используем SnapKit для установки constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(topOffset)
            make.centerX.equalToSuperview()
        }
    }


    
    private func setupGrid() {

        let gridSize: CGFloat
        let cellSize: CGFloat
        let borderWidth: CGFloat
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Настройки для iPad
            gridSize = isPreviewMode ? min(view.frame.width, view.frame.height) / 8 : min(view.frame.width, view.frame.height) / 2 - 20
            cellSize = gridSize / 3
            borderWidth = isPreviewMode ? 1 : 2
        } else {
            // Настройки для iPhone
            gridSize = isPreviewMode ? min(view.frame.width, view.frame.height) / 4 : min(view.frame.width, view.frame.height) - 60
            cellSize = gridSize / 3
            borderWidth = isPreviewMode ? 1 : 2
        }
        
        let gridContainer = UIView()
        gridContainer.backgroundColor = .clear
        gridContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridContainer)
        
        gridContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(gridSize)
        }
        
        for row in 0..<3 {
            for col in 0..<3 {
                let button = UIButton()
                button.setTitle("", for: .normal)
                button.backgroundColor = .white
                button.layer.borderWidth = borderWidth
                button.layer.borderColor = UIColor.black.cgColor
                button.titleLabel?.font = UIFont.systemFont(ofSize: cellSize * 0.6)
                button.titleLabel?.textAlignment = .center
                button.setTitleColor(.black, for: .normal)
                button.translatesAutoresizingMaskIntoConstraints = false
                gridContainer.addSubview(button)
                
                button.snp.makeConstraints { make in
                    make.width.height.equalTo(cellSize)
                    make.leading.equalTo(gridContainer.snp.leading).offset(CGFloat(col) * cellSize)
                    make.top.equalTo(gridContainer.snp.top).offset(CGFloat(row) * cellSize)
                }
                
                gameBoard[row][col] = button
                
                button.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
            }
        }
    }

    
    @objc private func handleTap(_ sender: UIButton) {
        // Игрок не может нажать на уже занятую ячейку
        guard sender.title(for: .normal) == "" else { return }
        
        sender.setTitle(currentPlayer, for: .normal)
        sender.setTitleColor(currentPlayer == "X" ? .black : .red, for: .normal)
        
        if checkForWinner() {
            showAlert(winner: currentPlayer)
        } else if checkForDraw() {
            showAlert(winner: nil)
        }
        
        // Смена игрока
        currentPlayer = (currentPlayer == "X") ? "O" : "X"
    }
    
    private func checkForWinner() -> Bool {
        let winPatterns: [[(Int, Int)]] = [
            // Горизонтали
            [(0, 0), (0, 1), (0, 2)],
            [(1, 0), (1, 1), (1, 2)],
            [(2, 0), (2, 1), (2, 2)],
            // Вертикали
            [(0, 0), (1, 0), (2, 0)],
            [(0, 1), (1, 1), (2, 1)],
            [(0, 2), (1, 2), (2, 2)],
            // Диагонали
            [(0, 0), (1, 1), (2, 2)],
            [(0, 2), (1, 1), (2, 0)]
        ]
        
        for pattern in winPatterns {
            let symbols = pattern.map { gameBoard[$0.0][$0.1]?.title(for: .normal) }
            if symbols.allSatisfy({ $0 == "X" }) || symbols.allSatisfy({ $0 == "O" }) {
                return true
            }
        }
        
        return false
    }
    
    private func checkForDraw() -> Bool {
        return gameBoard.flatMap { $0 }.allSatisfy { $0?.title(for: .normal) != "" }
    }
    
    private func showAlert(winner: String?) {
        var message: String
        
        if let winner = winner {
            message = "\(winner) wins!"
        } else {
            message = "It's a draw!"
        }
        
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Перезапуск игры после завершения
            self.resetGame()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func resetGame() {
        for row in 0..<3 {
            for col in 0..<3 {
                gameBoard[row][col]?.setTitle("", for: .normal)
            }
        }
        currentPlayer = "X" // Снова начинаем с "X"
    }
}
