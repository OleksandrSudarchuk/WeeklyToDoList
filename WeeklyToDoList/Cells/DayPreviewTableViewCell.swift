//
//  DayPreviewTableViewCell.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 13/01/2026.
//

import UIKit

class DayPreviewTableViewCell: UITableViewCell {
    //MARK: - Variable and Constant
    static let identifaier = "DayPreviewTableViewCell"
    
    //MARK: - UI Components
    let statusImageView = UIImageView()
    let titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = .systemFont(ofSize: 17)
        tl.numberOfLines = 1
        return tl
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        titleLabel.attributedText = nil
        contentView.backgroundColor = .clear
        statusImageView.image = nil
    }
    //MARK: - Functions
    func configure(text: String, done: Bool, priority: Int16?) {
        titleLabel.text = text
     
       statusImageView.image = UIImage(systemName: done ? "checkmark.circle.fill" : "circle")
        titleLabel.attributedText = TextStyleFormat.attributedText(text, isDone: done)
        
        contentView.backgroundColor = PriorityColor.from(priority)?.backgroundColor ?? .clear
       
    }
    
}

//MARK: - Extension
extension DayPreviewTableViewCell {
    func setupUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
            
        ])
    }
}
