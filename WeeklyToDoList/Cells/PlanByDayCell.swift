//
//  PlanByDayCell.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 30/12/2025.
//

import UIKit

class PlanByDayCell: UITableViewCell {
    
    //MARK: - Variable and Constant
    static let identifier = "PlanByDayCell"
    var onPrioritySelected: ((Int16?) -> Void)?
    var selectedPriority: Int16?
    
    //MARK: - UI Components
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let prioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Prio", for: .normal)
        return button
    }()
    
    let oneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("1", for: .normal)
        return button
    }()
    
    let twoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("2", for: .normal)
        return button
    }()

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        prioButton.addTarget(self, action: #selector(prioButtonTapped), for: .touchUpInside)
        oneButton.addTarget(self, action: #selector(oneButtonTapped), for: .touchUpInside)
        twoButton.addTarget(self, action: #selector(twoButtonTapped), for: .touchUpInside)
       
        setupUI()
        updateUI()
//        titleLabel.text = "INIT"
//        titleLabel.backgroundColor = .black
//        titleLabel.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    func configure(text: String, prioritySelected: Int16?) {
                titleLabel.text = text
        self.selectedPriority = prioritySelected
        updateUI()
    }
    
    
    func toggle(_ value: Int16) {
        if selectedPriority == value {
            selectedPriority = nil
        } else {
            selectedPriority = value
        }
        onPrioritySelected?(selectedPriority)
        updateUI()
    }
    
    func icon(for value: Int16) -> UIImage? {
        UIImage(systemName: selectedPriority == value ? "checkmark.circle.fill" : "circle")
        
    }
    
    func updateUI() {
        prioButton.setImage(icon(for: 0), for: .normal)
        oneButton.setImage(icon(for: 1), for: .normal)
        twoButton.setImage(icon(for: 2), for: .normal)
    }
    
    
    //MARK: - Selectors
    @objc func prioButtonTapped() {
        toggle(0)
    }
    @objc func oneButtonTapped() {
        toggle(1)
    }
    @objc func twoButtonTapped() {
        toggle(2)
    }
}
//MARK: - Extension
extension PlanByDayCell {
    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(prioButton)
        contentView.addSubview(oneButton)
        contentView.addSubview(twoButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        prioButton.translatesAutoresizingMaskIntoConstraints = false
        oneButton.translatesAutoresizingMaskIntoConstraints = false
        twoButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        prioButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        oneButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        twoButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
          
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: prioButton.leadingAnchor, constant: -12),
            
            
            prioButton.trailingAnchor.constraint(equalTo: oneButton.leadingAnchor, constant: -12),
            prioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            prioButton.heightAnchor.constraint(equalToConstant: 28),
            prioButton.widthAnchor.constraint(equalToConstant: 60),
            
            
            oneButton.trailingAnchor.constraint(equalTo: twoButton.leadingAnchor, constant: -12),
            oneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            oneButton.heightAnchor.constraint(equalToConstant: 28),
            oneButton.widthAnchor.constraint(equalToConstant: 40),
            
            twoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            twoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            twoButton.heightAnchor.constraint(equalToConstant: 28),
            twoButton.widthAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}
