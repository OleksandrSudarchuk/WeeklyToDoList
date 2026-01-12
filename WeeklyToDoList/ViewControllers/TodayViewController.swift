//
//  TodayViewController.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 12/11/2025.
//

import UIKit
import CoreData

class TodayViewController: UIViewController  {
 
    
    //MARK: - Variables
    var sections: [Section] = []
    var plannedBySection: [[PlannedTask]] = []
    var selectedDay: Date = DayCalendar.startOfDay(Date())
    //MARK: - UI Components
    let tableView = UITableView()
 
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderFooterView.identifier)
        tableView.register(TodayViewCell.self, forCellReuseIdentifier: TodayViewCell.identifier)
        setupUI()
        fetchToday()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchToday()
    }
    
    //MARK: - Selectors
    //MARK: - Functions
    
    
    func fetchToday() {
        let context = CoreDataStorage.shared.context
        let day = DayCalendar.startOfDay(Date())
        
        selectedDay = day
        
        let nextDay = DayCalendar.nextDay(from: day)
        
        let request: NSFetchRequest<PlannedTask> = PlannedTask.fetchRequest()
        request.predicate = NSPredicate(format: "day >= %@ AND day < %@", day as NSDate, nextDay as NSDate)
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "item.section.createdAt", ascending: true),
            NSSortDescriptor(key: "priority", ascending: true),
            NSSortDescriptor(key: "item.createdAt", ascending: true)
        ]
        
        do {
            let planned = try context.fetch(request)
           
            buildSectionModel(from: planned)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
           
        } catch {
            print("Error while retching data from PlannedTasks for Today: ", error)
        }
    }
    
    func buildSectionModel(from planned: [PlannedTask]) {
        let grouped = Dictionary(grouping: planned) { (pt) -> Section? in
            pt.item?.section
        }
        
        let sortedSection = grouped.keys.compactMap {$0}.sorted {
            ($0.createdAt ?? .distantPast) < ($1.createdAt ?? .distantPast)
        }
            self.sections = sortedSection
            self.plannedBySection = sortedSection.map { grouped[$0] ?? [] }
        
        
    }
    
  
}
//MARK: - Extensions
extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderFooterView.identifier) as! CustomHeaderFooterView
        header.configure(text: sections[section].titleOfSection ?? "")
        return header
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        plannedBySection[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayViewCell.identifier, for: indexPath) as! TodayViewCell
        let planned = plannedBySection[indexPath.section][indexPath.row]
        cell.configure(text: planned.item?.todos ?? "", done: planned.isDone, priority: planned.priority)
        cell.onDoneChange = { done in
            planned.isDone = done
            CoreDataStorage.shared.save()
        }
     
        return cell
        
    }
}

extension TodayViewController {
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        ])
    }
}
