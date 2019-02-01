//
//  ViewController.swift
//  SHTabBar
//
//  Created by Adrian Perte on 29/01/2019.
//  Copyright © 2019 softhaus. All rights reserved.
//

import UIKit

class ViewController: ScrollViewController {
    
    var vc1: UIViewController!
    var vc2: UIViewController!
    var vc3: UIViewController!
    var vc4: UIViewController!


    override func viewDidLoad() {
        super.viewDidLoad()

        vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc1")
        vc1.view.backgroundColor = UIColor(red:0.34, green:0.24, blue:0.69, alpha:1.00)
        
        vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc2")
        vc2.view.backgroundColor = UIColor(red:0.72, green:0.27, blue:0.59, alpha:1.00)

        vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc3")
        vc3.view.backgroundColor = UIColor(red:0.87, green:0.67, blue:0.25, alpha:1.00)

        vc4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc4")
        vc4.view.backgroundColor = UIColor(red:0.26, green:0.57, blue:0.65, alpha:1.00)

        self.viewControllers = [vc1,vc2,vc3,vc4]
        self.tabBarView.dataSource = self
        self.tabBarView.delegate = self
        self.tabBarView.reloadData()

        

    }
    
}
extension ViewController: TabBarViewDataSource{
    func numberOfItems(inTabSwitcher tabSwitcher: TabBarView) -> Int {
        return 4
    }
    
    func tabSwitcher(_ tabSwitcher: TabBarView, titleAt index: Int) -> String {
        switch index {
        case 0:
            return "Home"
        case 1:
            return "Messages"
        case 2:
            return "Mail"
        case 3:
            return "Profile"
        default:
            return ""
        }
    }
    
    func tabSwitcher(_ tabSwitcher: TabBarView, iconAt index: Int) -> UIImage {
        switch index {
        case 0:
            return UIImage(named: "1")!
        case 1:
            return UIImage(named: "2")!
        case 2:
            return UIImage(named: "3")!
        case 3:
            return UIImage(named: "4")!
        default:
            return UIImage(named: "1")!
        }
    }
    
    func tabSwitcher(_ tabSwitcher: TabBarView, hightlightedIconAt index: Int) -> UIImage {
        switch index {
        case 0:
            return UIImage(named: "1")!
        case 1:
            return UIImage(named: "2")!
        case 2:
            return UIImage(named: "3")!
        case 3:
            return UIImage(named: "4")!
        default:
            return UIImage(named: "1")!

        }
    }
    
    func tabSwitcher(_ tabSwitcher: TabBarView, tintColorAt index: Int) -> UIColor {
        switch index {
        case 0:
            return UIColor(red:0.34, green:0.24, blue:0.69, alpha:1.00)
        case 1:
            return UIColor(red:0.72, green:0.27, blue:0.59, alpha:1.00)
        case 2:
            return UIColor(red:0.87, green:0.67, blue:0.25, alpha:1.00)
        case 3:
            return UIColor(red:0.26, green:0.57, blue:0.65, alpha:1.00)
        default:
            return .black
        }        
    }
    
    
}

