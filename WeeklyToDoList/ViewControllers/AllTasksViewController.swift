//
//  AllTasksViewController.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 12/11/2025.
//

import UIKit
import CoreData

class AllTasksViewController: UIViewController  {
    
    
    //MARK: - Variables and constants
    var sections: [Section] = []
    
    
    //MARK: - UIComponets
    let tableView = UITableView()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        view.backgroundColor = .magenta
       
        setUpConstraints()
        fetchReqeust()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addSectionButtonAction))
        tableView.register(AllTasksToDoCell.self, forCellReuseIdentifier: AllTasksToDoCell.identifier)
        tableView.register(AllTasksHeaderCell.self, forHeaderFooterViewReuseIdentifier: AllTasksHeaderCell.identifier)
    }
    
    //MARK: - Selectors
    @objc func addSectionButtonAction() {
        
        let newSection = Section(context: CoreDataStorage.shared.context)
        newSection.createdAt = Date()
        newSection.titleOfSection = ""
        
        sections.append(newSection)
        CoreDataStorage.shared.save()
        fetchReqeust()
        
    }
    
    //MARK: - Functions
    func fetchReqeust() {
        do {
            let requeste = Section.fetchRequest() as NSFetchRequest<Section>
            let sort = NSSortDescriptor(key:"createdAt" , ascending: true)
            requeste.sortDescriptors = [sort]
            self.sections = try CoreDataStorage.shared.context.fetch(requeste)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Fetch reqeuste error:", error)
        }
    }
    
    private func addRowToSectionAction(to section: Section) {
        
        let newRow = Item(context: CoreDataStorage.shared.context)
        newRow.todos = ""
        newRow.createdAt = Date()
        newRow.section = section
        
        CoreDataStorage.shared.save()
        fetchReqeust()
        
        
    }
    
    func sortItem( in sectionIndex: Int) -> [Item] {
        let sectionObject = sections[sectionIndex]
        let setObject = sectionObject.item as? Set<Item> ?? []
        let sortedObject = setObject.sorted { ($0.createdAt ?? .distantPast) < ($1.createdAt ?? .distantPast)}
        
        return sortedObject
    }
    
}

//MARK: - Extensions
extension AllTasksViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: - Header cell
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AllTasksHeaderCell.identifier) as? AllTasksHeaderCell else {
            fatalError("Faile to create header cell.")
        }
        
        let sectionModel = sections[section]
        header.configure(with: sectionModel.titleOfSection ?? "" )
        header.onTextChange = { newText in
            
            sectionModel.titleOfSection = newText
            
            CoreDataStorage.shared.save()
            
            
        }
        
        header.onButtonAdd = { [weak self] in
            guard let self = self else {return}
            self.addRowToSectionAction(to: sectionModel)
            
        }
        
        header.onBottonDelete = { [weak self] in
            guard let self = self else {return}
            let alarm = UIAlertController(title: "Delete section", message: "Do you want to delete \(sectionModel.titleOfSection ?? "") section?", preferredStyle: .alert)
            alarm.addAction(UIAlertAction(title: "Delete", style: .default) { _ in
                let deleteSection = sectionModel
                
                CoreDataStorage.shared.context.delete(deleteSection)
                
                CoreDataStorage.shared.save()
                self.fetchReqeust()
            })
            alarm.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alarm, animated: true)
            
        }
        return header
    }
    
 
    
    //MARK: - Noramal cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortItem(in: section).count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllTasksToDoCell.identifier, for: indexPath) as! AllTasksToDoCell
        
        let sectionItem = sortItem(in: indexPath.section)
        let rowItem = sectionItem[indexPath.row]
        cell.configure(text: rowItem.todos ?? "")
        
        cell.onTextChange = { text in
           
            rowItem.todos = text
            
            CoreDataStorage.shared.save()
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sortedRow = sortItem(in: indexPath.section)
            let deleteRow = sortedRow[indexPath.row]
            
            CoreDataStorage.shared.context.delete(deleteRow)
            CoreDataStorage.shared.save()
            fetchReqeust()
            
        }
    }
}

extension AllTasksViewController {
    
    
    func setUpConstraints() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}





