//
//  DayPreviewSectionHeaderFooterView.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 13/01/2026.
//

import UIKit

class DayPreviewSectionHeaderFooterView: UITableViewHeaderFooterView {
    //MARK: - Variable and Constant
static let identifier = "DayPreviewSectionHeaderFooterView"
    
    //MARK: - UI Components
    let titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = .systemFont(ofSize: 15, weight: .semibold)
        tl.textColor = .label
        return tl
    }()
    //MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    func configure(with text: String) {
        titleLabel.text = text
    }
}
//MARK: - Extension

extension DayPreviewSectionHeaderFooterView {
    func setupUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        ])
    }
}
