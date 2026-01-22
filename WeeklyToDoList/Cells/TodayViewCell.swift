//
//  TodayViewCell.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 05/01/2026.
//

import UIKit

class TodayViewCell: UITableViewCell {
    //MARK: - Variable and Constant
static let identifier = "TodayViewCell"
    
    var onDoneChange: ((Bool) -> Void)?
    var isDone: Bool = false
    var priorityRaw: Int16?
    
    //MARK: - UI Components
    let titleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        setupUI()
        updateIconeButton()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onDoneChange = nil
        titleLabel.attributedText = nil
        isDone = false
        priorityRaw = nil
        contentView.backgroundColor = .clear
        updateIconeButton()
        
    }
    
    //MARK: - Functions
    func configure(text: String, done: Bool, priority: Int16? ) {
        titleLabel.text = text
        isDone = done
        self.priorityRaw = priority
        updateIconeButton()
        priorityBackround()
        titleLabel.attributedText = TextStyleFormat.attributedText(text, isDone: done)
        
    }
    
    func updateIconeButton() {
        let name = isDone ? "checkmark.circle.fill" : "circle"
        doneButton.setImage(UIImage(systemName: name), for: .normal)
    }
    
  
    func priorityBackround() {
        contentView.backgroundColor = PriorityColor.from(priorityRaw)?.backgroundColor ?? .clear
    }

    //MARK: - Selectors
    @objc func doneTapped() {
        isDone.toggle()
        updateIconeButton()
        let text = titleLabel.text ?? ""
        titleLabel.attributedText = TextStyleFormat.attributedText(text, isDone: self.isDone)
        onDoneChange?(isDone)
    }
}

//MARK: - Extension
extension TodayViewCell {
    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(doneButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        doneButton.setContentHuggingPriority(.required, for: .horizontal)
        doneButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
           
         
          
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 40),
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            
            contentView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.topAnchor, constant: -10 ),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 10 )
                    
         
        ])
    }
}
