//
//  CellHeader.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 18/11/2025.
//

import UIKit

class CellHeader: UITableViewHeaderFooterView {
    
    //MARK: - Variable and Constant
    static let identifier = "CellHeader"
    
    var onButtonAdd: (() -> Void)?
    var onTextChange: ((String) -> Void)?
    var onBottonDelete: (() -> Void)?
    
    //MARK: - UI Components
    private let cellTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 20)
        tf.textAlignment = .left
        return tf
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    //MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpUI()
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        cellTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        deleteButton.addTarget(self, action: #selector(buttonDeleteTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    public func configure(with text: String) {
        cellTextField.text = text
    }
    //MARK: - Selectors
    @objc   func textChange(_ textField: UITextField) {
        onTextChange?(textField.text ?? "")
    }
    @objc func addButtonTapped() {
        onButtonAdd?()
    }
    @objc func buttonDeleteTapped() {
        onBottonDelete?()
    }
    
}

//MARK: - Extension Layout
extension CellHeader {
    func setUpUI() {
        let bgView = UIView()
        bgView.backgroundColor = .gray
        backgroundView = bgView
        
        contentView.addSubview(cellTextField)
        contentView.addSubview(addButton)
        contentView.addSubview(deleteButton)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        cellTextField.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            cellTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            
            addButton.leadingAnchor.constraint(equalTo: cellTextField.trailingAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            addButton.widthAnchor.constraint(equalToConstant: 35),
            addButton.heightAnchor.constraint(equalToConstant: 35),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 8),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            deleteButton.widthAnchor.constraint(equalToConstant: 35),
            deleteButton.heightAnchor.constraint(equalToConstant: 35),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
    }
    
}


