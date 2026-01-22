//
//  CalendarViewController.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 12/01/2026.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController {
   //fix problem with select day in calendar, can't choose day twice in row. Make days in calendar fill if they have plan 
    
    //MARK: - Variables
    let calendarView = UICalendarView()
    var selection: UICalendarSelectionSingleDate!
    
    //MARK: - UI Components
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        setupUI()
        
    }
    
    //MARK: - Functions
    func hasPlan( for day: Date) -> Bool {
        let context = CoreDataStorage.shared.context
        let start = DayCalendar.startOfDay(day)
        let end = DayCalendar.nextDay(from: start)
        
        let request: NSFetchRequest<PlannedTask> = PlannedTask.fetchRequest()
        request.predicate = NSPredicate(format: "day >= %@ AND day < %@", start as NSDate, end as NSDate)
        
        do { return try context.count(for: request) > 0}
        catch {
            print("hasPlan error :", error); return false
        }
    }
    
    func openFlow(for day: Date) {
        let start = DayCalendar.startOfDay(day)
        
        if hasPlan(for: start) {
            let vc = DayPreviewViewController(day: start)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = PlanByDayViewController(day: start)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    //MARK: - Selectors
}
//MARK: - Extensions

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let components = dateComponents,
              let date = DayCalendar.calendar.date(from:components) else {return}
        
        let day = DayCalendar.startOfDay(date)
        let vc = DayPreviewViewController(day: day)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CalendarViewController {
    func setupUI() {
        view.addSubview(calendarView)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
