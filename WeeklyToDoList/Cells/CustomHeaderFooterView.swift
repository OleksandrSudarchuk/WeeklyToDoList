//
//  CustomHeaderFooterView.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 10/01/2026.
//

import UIKit

class CustomHeaderFooterView: UITableViewHeaderFooterView {
   
    //MARK: - Variable and Constant
static let identifier = "CustomHeaderFooterView"

    //MARK: - UI Components
    let titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = .systemFont(ofSize: 17)
        tl.textColor = .white
        return tl
    }()
    
    //MARK: - Init
    override init(reuseIdentifier: String?) {
        super .init(reuseIdentifier: reuseIdentifier)
        setupUI()
        contentView.backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    func configure(text: String) {
        titleLabel.text = text
    }
    
}

 //MARK: - Extension

extension CustomHeaderFooterView {
   func setupUI() {
       contentView.addSubview(titleLabel)
       
       titleLabel.translatesAutoresizingMaskIntoConstraints = false
       
       NSLayoutConstraint.activate([
        titleLabel.topAnchor.constraint(equalTo:contentView.topAnchor),
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
