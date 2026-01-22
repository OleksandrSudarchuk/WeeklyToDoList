//
//  PlanByDayViewController.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 12/11/2025.
//

import UIKit
import CoreData

class PlanByDayViewController: UIViewController {
    
    
    //MARK: - Variables
    var sections: [Section] = []
    var itemsBySection: [[Item]] = []
    let day: Date
    var selectedItemIds: [NSManagedObjectID : Int16] = [:]
   
    
    //MARK: - UI Components

    let tableView = UITableView()
    
    //MARK: - LifeCycle
    init(day: Date) {
        self.day = DayCalendar.startOfDay(day)
        super.init(nibName: nil, bundle: nil)
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(CustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderFooterView.identifier)
        tableView.register(PlanByDayCell.self, forCellReuseIdentifier: PlanByDayCell.identifier)
        fetchDataFromAllTasks()
        setupUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(confirmButtonTapped))
       
        loadPlan(for: self.day)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromAllTasks()
        loadPlan(for: self.day)
        title = DayDateFornatter.title(for: day)
    }
    //MARK: - Selectors
    @objc func confirmButtonTapped() {
       
        savePlan(for: day)
        let perviewVC = DayPreviewViewController(day: day)
        navigationController?.setViewControllers(navigationController?.viewControllers.dropLast() ?? [] + [perviewVC], animated: true)

    }
    //MARK: - Functions
    func fetchDataFromAllTasks() {
        let request: NSFetchRequest<Section> = Section.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        do {
            let fetchedSections = try CoreDataStorage.shared.context.fetch(request)
            self.sections = fetchedSections
        
            
          let itemsBySectionRequest = fetchedSections.map { section  in
                let set = section.item as? Set<Item> ?? []
                return set
                  .filter { item in
                      let text = (item.todos ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                      return !text.isEmpty
                  }
              .sorted { ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast)}}
            self.itemsBySection = itemsBySectionRequest
            
                self.tableView.reloadData()
            
        } catch {
            print("Error while fetch data from CoreData to display in PlanByDay: ", error)
        }
    }
    
    func savePlan(for day: Date) {
        let context = CoreDataStorage.shared.context
        
        // 1 Fetch all PlannedTask for this day
        let request: NSFetchRequest<PlannedTask> = PlannedTask.fetchRequest()
        let nextDay = DayCalendar.nextDay(from: day)
        
        request.predicate = NSPredicate(format: "day >= %@ AND day < %@", day as NSDate, nextDay as NSDate)
        
        do {
            let existing  = try context.fetch(request)
            
            var existingByItemID: [NSManagedObjectID: PlannedTask] = [:]
            for pt in existing {
                if let item = pt.item {
                    existingByItemID[item.objectID] = pt
                }
            }
            // Upsert for selected item create/refresh PlannedTask
            for(itemObjectID, prio) in selectedItemIds {
                let item = try context.existingObject(with: itemObjectID) as! Item
               if let planned = existingByItemID[itemObjectID] {
                    planned.priority = prio
               } else {
                   let planned = PlannedTask(context: context)
                   planned.day = day
                   planned.priority = prio
                   planned.isDone = false
                   planned.item = item
                   planned.createdAt = Date()
               }
            }
            
            // Delete from this day that PlannedTasks which one not selected
            let selectedKeys = Set(selectedItemIds.keys)
            for pt in existing {
                guard let item = pt.item else {continue}
                if !selectedKeys.contains(item.objectID) {
                    context.delete(pt)
                }
            }
            
            CoreDataStorage.shared.save()
           
        } catch {
            print("Error while saving PlannedTask: ", error)
        }
    }
    
    func loadPlan(for day: Date) {
        let context = CoreDataStorage.shared.context
        
        let request: NSFetchRequest<PlannedTask> = PlannedTask.fetchRequest()
        let nextDay = DayCalendar.nextDay(from: day)
        request.predicate = NSPredicate(format: "day >= %@ AND day < %@", day as NSDate, nextDay as NSDate)
        
        do {
            let planned = try context.fetch(request)
            
            selectedItemIds.removeAll()
            
            for pt in planned {
                guard let item = pt.item else { continue }
                selectedItemIds[item.objectID] = pt.priority
            }
        
            self.tableView.reloadData()
            
        } catch {
            print("Error while fetching PlannedTasks: ", error)
        }
    }
  
}

//MARK: - Extensions
extension PlanByDayViewController: UITableViewDataSource, UITableViewDelegate  {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderFooterView.identifier) as! CustomHeaderFooterView
        header.configure(text: sections[section].titleOfSection ?? "")

        return header
    }

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsBySection[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanByDayCell.identifier, for: indexPath) as! PlanByDayCell
        let item = itemsBySection[indexPath.section][indexPath.row]
        let key = item.objectID
        let selectedPriority = selectedItemIds[key]
        
        cell.configure(text: item.todos ?? "", prioritySelected: selectedPriority)

        
        cell.onPrioritySelected = { [weak self] priority in
            guard let self else {return}
            
            if let prio = priority {
                self.selectedItemIds[key] = prio
            } else {
                self.selectedItemIds.removeValue(forKey: key)
            }
        }
   
        return cell
    }
}

extension PlanByDayViewController {
    func setupUI() {
        view.addSubview(tableView)
  
        tableView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
         
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
}
