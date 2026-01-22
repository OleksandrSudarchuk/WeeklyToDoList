//
//  DayPreviewViewController.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 12/01/2026.
//

import UIKit
import CoreData

class DayPreviewViewController: UIViewController {
    
    //MARK: - Variables
    let day: Date
    var sections: [Section] = []
    var plannedTasks: [[PlannedTask]] = []
    var totalCount: Int = 0 {
        didSet {
            updateUIState()
        }
    }
    
    //MARK: - UI Components
    let noPannedTasksLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 0
        l.textColor = .secondaryLabel
        l.text = "No planned tasks for this day"
        return l
    }()
    
    lazy var craetePlaanButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createPlanTapeed))
    lazy var editePlanButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editPlanTapped))

    let tableView = UITableView()
    
    let buttonStackView: UIStackView = {
        let bs = UIStackView()
        bs.axis = .horizontal
        bs.distribution = .fillEqually
        return bs
    }()
    
    //MARK: Init
    init(day: Date) {
        self.day = DayCalendar.startOfDay(day)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DayPreviewSectionHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: DayPreviewSectionHeaderFooterView.identifier)
        tableView.register(DayPreviewTableViewCell.self, forCellReuseIdentifier: DayPreviewTableViewCell.identifaier)
        setupUI()
        title = DayDateFornatter.title(for: day)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequeste()
        updateUIState()
    }
    
    //MARK: - Functions
    func fetchRequeste() {
        let context = CoreDataStorage.shared.context
        let start = day
        let end = DayCalendar.nextDay(from: start)
        let req: NSFetchRequest<PlannedTask> = PlannedTask.fetchRequest()
        
        req.predicate = NSPredicate(format: "day >= %@ AND day < %@", start as NSDate, end as NSDate)
        req.sortDescriptors = [
            NSSortDescriptor(key: "item.section.createdAt", ascending: true),
            NSSortDescriptor(key: "priority", ascending: true),
            NSSortDescriptor(key: "item.createdAt", ascending: true)
        ]
        
        do {
            let planned = try context.fetch(req)
            buildSectionModel(from: planned)
            totalCount = plannedTasks.count
            tableView.reloadData()
        } catch {
            print("DayPreview fetch error: ", error)
        }
    }
    
    
        func buildSectionModel(from planned: [PlannedTask]) {
            let grouped = Dictionary(grouping: planned) {
                $0.item?.section
            }
            
            let sortedSections = grouped.keys.compactMap {$0}.sorted { ( $0.createdAt ?? .distantPast) < ($1.createdAt ?? .distantPast)}
            sections = sortedSections
            plannedTasks = sortedSections.map { grouped[$0] ?? [] }
        }
    
    func updateUIState() {
    
        if totalCount == 0 {
            tableView.isHidden = true
            noPannedTasksLabel.isHidden = false
            navigationItem.rightBarButtonItem = craetePlaanButton

        } else {
            tableView.isHidden = false
            noPannedTasksLabel.isHidden = true
            navigationItem.rightBarButtonItem = editePlanButton
        }
    }
    
    //MARK: - Selectors
    @objc func createPlanTapeed() {
        let vc = PlanByDayViewController(day: day)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func editPlanTapped() {
        let vc = PlanByDayViewController(day: day)
        navigationController?.pushViewController(vc, animated: true)
    }

}

//MARK: - Extensions
extension DayPreviewViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DayPreviewSectionHeaderFooterView.identifier) as! DayPreviewSectionHeaderFooterView
        header.configure(with: sections[section].titleOfSection ?? "")
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        plannedTasks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DayPreviewTableViewCell.identifaier, for: indexPath) as! DayPreviewTableViewCell
        let path = plannedTasks[indexPath.section][indexPath.row]
        cell.configure(text: path.item?.todos ?? "", done: path.isDone, priority: path.priority)
        
        return cell
    }
}

extension DayPreviewViewController {
    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(noPannedTasksLabel)
        view.addSubview(buttonStackView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        noPannedTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo:view.trailingAnchor),
            
           
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -32),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40),
            
            noPannedTasksLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            noPannedTasksLabel.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -24),
            noPannedTasksLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPannedTasksLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        ])
    }
}
