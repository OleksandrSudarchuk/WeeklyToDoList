//
// AllTasksToDoCell.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 19/11/2025.
//

import UIKit

class AllTasksToDoCell: UITableViewCell {
    //MARK: - Variable and Constant

    static let identifier = "CellDoTo"
    
    var onTextChange: ((String) -> Void)?
    
    //MARK: - UI Components
    let textField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 17)
        field.textAlignment = .left
        return field
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    func configure(text: String) {
        textField.text = text
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        onTextChange?(textField.text ?? "" )
    }
}

//MARK: - Extension
extension AllTasksToDoCell {
    func setUpUI() {
        contentView.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 42)
           
        ])
        
        
    }
}
 
