//
//  DataPickerView.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 29/12/2025.
//

import UIKit

class DataPickerView: UIView {
    //MARK: - Variable and Constant
    var onDateChanged: ((Date) -> Void)?
    
    //MARK: - UI Components
  private let dataPicker = UIDatePicker()
    
    let textField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 17)
        field.textAlignment = .left
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.systemBlue.cgColor
        field.layer.cornerRadius = 10
        field.placeholder = "Select date"
        return field
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: .zero)
        createDataPicker()
        setupUI()
        dataPicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    func createToolBar() -> UIToolbar {
       let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        toolBar.setItems([doneButton, cancelButton], animated: true)
        
        return toolBar
    }
    
    func createDataPicker() {
        dataPicker.datePickerMode = .date
        dataPicker.preferredDatePickerStyle = .wheels
        
        textField.inputAccessoryView = createToolBar()
        textField.inputView = dataPicker
    }
    
//MARK: - Selector
    @objc func  doneButtonTapped() {
        let dataFormatter = DateFormatter()
        dataFormatter.dateStyle = .medium
        dataFormatter.timeStyle = .none
        
        self.textField.text = dataFormatter.string(from: dataPicker.date)
        self.endEditing(true)
    }
    
    @objc func cancelButtonTapped() {
        textField.resignFirstResponder()
    }
    
    @objc func dateChange() {
        onDateChanged?(dataPicker.date)
    }
}

//MARK: - Extension
extension DataPickerView {
    func setupUI() {
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
