//
//  ViewController.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 12/11/2025.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.tabBar.isTranslucent = false
        
        setUpTabBar()
    }
//MARK: - Functions
    func createNavigationBar(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.viewControllers.first?.title = title
        navController.navigationBar.isTranslucent = false
        return navController
    }
    func setUpTabBar() {
        let allTasksVC = createNavigationBar(with: "All tasks", and: UIImage(systemName: "list.bullet.clipboard"), vc: AllTasksViewController())
        let calendarVC = createNavigationBar(with: "Calendar", and: UIImage(systemName: "calendar.badge.plus"), vc: CalendarViewController())
        let todayVC = createNavigationBar(with: "Today do", and: UIImage(systemName: "checklist"), vc: TodayViewController())
        let statsVC = createNavigationBar(with: "Your statistics", and: UIImage(systemName: "chart.line.uptrend.xyaxis"), vc: StatsViewController())
        self.setViewControllers([todayVC, calendarVC, allTasksVC, statsVC], animated: true)
       
    }

}

