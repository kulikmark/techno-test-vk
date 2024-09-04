//
//  MainViewController.swift
//  techno-test-vk
//
//  Created by Марк Кулик on 03.09.2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    private let tableView = UITableView()
    private var isHalfScreenMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupToggleButton()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setupToggleButton() {
        let toggleButton = UIBarButtonItem(title: "Change View", style: .plain, target: self, action: #selector(toggleMode))
        navigationItem.rightBarButtonItem = toggleButton
    }

    @objc private func toggleMode() {
        isHalfScreenMode.toggle()
        tableView.reloadData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Удаление всех предыдущих subview перед добавлением новых
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let index = indexPath.row % 4
        let widget: UIViewController
        
        switch index {
        case 0:
            widget = WeatherWidget()
        case 1:
            widget = CityWidget()
        case 2:
            widget = CrosswordWidget(isPreviewMode: !isHalfScreenMode)
        case 3:
            widget = TicTacToeWidget(isPreviewMode: !isHalfScreenMode)
        default:
            return cell
        }
        
        // Отключение взаимодействия в режиме 1/8 экрана
        widget.view.isUserInteractionEnabled = isHalfScreenMode
        
        configureWidget(widget, in: cell)
        return cell
    }


    private func configureWidget(_ widget: UIViewController, in cell: UITableViewCell) {
        addChild(widget)
        widget.view.frame = cell.contentView.bounds
        widget.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.contentView.addSubview(widget.view)
        widget.didMove(toParent: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isHalfScreenMode ? view.frame.height / 2 : view.frame.height / 8
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isHalfScreenMode else { return }
        
        let index = indexPath.row % 4
        let selectedWidget: UIViewController?
        
        switch index {
        case 0:
            selectedWidget = WeatherWidget()
        case 1:
            selectedWidget = CityWidget()
        case 2:
            selectedWidget = CrosswordWidget(isPreviewMode: false)
        case 3:
            selectedWidget = TicTacToeWidget(isPreviewMode: false)
        default:
            selectedWidget = nil
        }

        if let widget = selectedWidget {
            navigationController?.pushViewController(widget, animated: true)
        }
    }
}
