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
    var priority: Int16?
    
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
        priority = nil
        contentView.backgroundColor = .clear
        updateIconeButton()
        
    }
    
    //MARK: - Functions
    func configure(text: String, done: Bool, priority: Int16? ) {
        titleLabel.text = text
        isDone = done
        self.priority = priority
        updateIconeButton()
        crossText(text)
        updatePriorityLabel()
        
    }
    
    func updateIconeButton() {
        let name = isDone ? "checkmark.circle.fill" : "circle"
        doneButton.setImage(UIImage(systemName: name), for: .normal)
    }
    
    func crossText(_ text: String) {
        
        
        if isDone {
            titleLabel.attributedText = NSAttributedString(string: text, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.secondaryLabel
            ])
        } else {
            titleLabel.attributedText = NSAttributedString(string: text, attributes: [
                .strikethroughStyle: 0,
                .foregroundColor: UIColor.label])
        }
    }
    
    func priorityLabelBackround(for priority: Int16?) -> UIColor {
        switch priority {
        case 0:
            return UIColor.systemRed.withAlphaComponent(0.15)
        case 1:
            return UIColor.systemYellow.withAlphaComponent(0.15)
        case 2:
            return UIColor.systemGreen.withAlphaComponent(0.15)
        default:
            return .clear
        }
    }
    
    func updatePriorityLabel() {
        contentView.backgroundColor = priorityLabelBackround(for: priority)
    }
    

    //MARK: - Selectors
    @objc func doneTapped() {
        isDone.toggle()
        updateIconeButton()
        let text = titleLabel.attributedText?.string ?? ""
        crossText(text)
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
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: doneButton.leadingAnchor, constant: -8),
           
         
          
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 40),
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            
            contentView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.topAnchor, constant: -10 ),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 10 )
                    
         
        ])
    }
}
