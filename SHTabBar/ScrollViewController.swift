//
//  ScrollViewController.swift
//  SHTabBar
//
//  Created by Adrian Perte on 29/01/2019.
//  Copyright © 2019 softhaus. All rights reserved.
//

import UIKit
public protocol ScrollViewDelegate: class {
    func moveScrollViewTo(scrollView: UIScrollView,_ index: Int)
}
open class ScrollViewController: UIViewController {
    open weak var scrollViewDelegate: ScrollViewDelegate?
    var scrollView: UIScrollView!
    var viewControllers: [UIViewController]!{
        didSet{
            addViews()
        }
    }
    var tabBarView: TabBarView = TabBarView()

    var buttons: [UIButton] {
        get{
            return self.tabBarView.buttons
        }
        set{
            self.tabBarView.buttons = newValue
        }
    }
    var labels: [UILabel] {
        get{
            return self.tabBarView.labels
        }
        set{
            self.tabBarView.labels = newValue
        }
    }
    

    func setUp(){
        self.scrollView = UIScrollView(frame: self.view.frame)
        self.scrollView.isPagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.backgroundColor = .clear
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isUserInteractionEnabled = false
        self.view.addSubview(self.scrollView)
        
        self.tabBarView = TabBarView()
        self.view.addSubview(self.tabBarView)
        
        self.tabBarView.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tabBarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tabBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tabBarView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.tabBarView.backgroundColor = .white
        
        


    }
    
    func addViews(){
        setUp()
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(self.viewControllers.count), height: self.view.bounds.height)
        self.viewControllers.enumerated().forEach { (controller) in
            self.addChild(controller.element)
            self.scrollView?.addSubview(controller.element.view)
            controller.element.didMove(toParent: self)
            controller.element.view.frame = CGRect(origin: CGPoint(x: self.view.bounds.width * CGFloat(controller.offset) , y: 0), size: self.view.bounds.size)
        }
        self.buttons.forEach({self.tabBarView.stackView.addArrangedSubview($0)})

    }
}
extension ScrollViewController: TabBarViewDelegate {
    public func didSelectItemAt(_ index: Int) {
        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(index), y: 0), animated: true)
    }
    
    
}


public protocol TabBarViewDataSource: class {
    
    func numberOfItems(inTabSwitcher tabSwitcher: TabBarView) -> Int
    func tabSwitcher(_ tabSwitcher: TabBarView, titleAt index: Int) -> String
    func tabSwitcher(_ tabSwitcher: TabBarView, iconAt index: Int) -> UIImage
    func tabSwitcher(_ tabSwitcher: TabBarView, hightlightedIconAt index: Int) -> UIImage
    func tabSwitcher(_ tabSwitcher: TabBarView, tintColorAt index: Int) -> UIColor
    
}
public protocol TabBarViewDelegate: class {
    func didSelectItemAt(_ index: Int)
}


open class TabBarView: UIView {
    var stackView: UIStackView = UIStackView()
    var buttons: [UIButton] = []
    var labels: [UILabel] = []
    open weak var dataSource: TabBarViewDataSource?
    open weak var delegate: TabBarViewDelegate?
    open var selectedSegmentIndex: Int = 0 {
        didSet {
            if oldValue != selectedSegmentIndex {
                transition(from: oldValue, to: selectedSegmentIndex)
                delegate?.didSelectItemAt(selectedSegmentIndex)
            }
        }
    }
    private(set) lazy var highlighterView: UIView = {

        let frame = CGRect(origin: CGPoint(x: 0, y: 10), size: CGSize(width: 0, height: self.bounds.height - 20))
        let highlighterView = UIView(frame: frame)
        highlighterView.layer.cornerRadius = (self.bounds.height - 20) / 2
        highlighterView.alpha = 0.1
        self.addSubview(highlighterView)
        self.sendSubviewToBack(highlighterView)
        
        return highlighterView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override open var frame: CGRect {
        didSet {
            self.stackView.frame = self.bounds
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            self.stackView.frame = self.bounds
        }
    }
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            layoutIfNeeded()
            let countItems = dataSource?.numberOfItems(inTabSwitcher: self) ?? 0
            if countItems > selectedSegmentIndex {
                transition(from: selectedSegmentIndex, to: selectedSegmentIndex)
            }
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        moveHighlighterView(toItemAt: selectedSegmentIndex)
    }
    
    func commonInit() {
        self.addSubview(self.stackView)
        self.stackView.distribution = .fillEqually
        self.stackView.alignment = .center

        
    }
    func reloadData(){
        guard let dataSource = dataSource else {
            return
        }
        self.buttons.forEach({$0.removeFromSuperview()})
        self.labels.forEach({$0.removeFromSuperview()})
        self.buttons = []
        self.labels = []
        let count = dataSource.numberOfItems(inTabSwitcher: self)
        for index in 0..<count{
            let button = createButton(forIndex: index, withDataSource: dataSource)
            buttons.append(button)
            stackView.addArrangedSubview(button)
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.layer.cornerRadius = 25
            
            let label = createLabel(forIndex: index, withDataSource: dataSource)
            label.text = dataSource.tabSwitcher(self, titleAt: index)
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true

            labels.append(label)
            stackView.addArrangedSubview(label)
            
        }
    }
    
    func createButton(forIndex index: Int, withDataSource dataSource: TabBarViewDataSource) -> UIButton {
        let button = UIButton()
        
        button.setImage(dataSource.tabSwitcher(self, iconAt: index), for: .normal)
        button.setImage(dataSource.tabSwitcher(self, hightlightedIconAt: index).withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = dataSource.tabSwitcher(self, tintColorAt: index)
        button.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        
        return button
    }
    @objc func selectButton(_ sender: UIButton) {
        if let index = buttons.index(of: sender) {
            selectedSegmentIndex = index
        }
    }
    
    func createLabel(forIndex index: Int, withDataSource dataSource: TabBarViewDataSource) -> UILabel {
        let label = UILabel()
        
        label.isHidden = true
        label.textAlignment = .left
        label.text = dataSource.tabSwitcher(self, titleAt: index)
        label.textColor = dataSource.tabSwitcher(self, tintColorAt: index)
//        label.adjustsFontSizeToFitWidth = true
//        label.layoutSubviews()

        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        return label
    }
    func transition(from fromIndex: Int, to toIndex: Int) {
            let fromLabel = labels[fromIndex]
            let fromIcon = buttons[fromIndex]
            let toLabel = labels[toIndex]
            let toIcon = buttons[toIndex]
        
        let animation = {
            fromLabel.isHidden = true
            fromLabel.alpha = 0
            fromIcon.isSelected = false
            
            toLabel.isHidden = false
            toLabel.alpha = 1
            toIcon.isSelected = true
            
            self.stackView.layoutIfNeeded()
            self.layoutIfNeeded()
            self.moveHighlighterView(toItemAt: toIndex)
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            animations: animation,
            completion: nil
        )
    }
    
    func moveHighlighterView(toItemAt toIndex: Int) {
        guard let countItems = dataSource?.numberOfItems(inTabSwitcher: self), countItems > toIndex else {
            return
        }
        
        let toLabel = labels[toIndex]
        let toIcon = buttons[toIndex]
        let point = convert(toIcon.frame.origin, to: self)
        highlighterView.frame.origin.x = point.x + 10
        highlighterView.frame.size.width = toLabel.bounds.width + toIcon.bounds.width //(toLabel.frame.origin.x - toIcon.frame.origin.x)
        highlighterView.backgroundColor = dataSource!.tabSwitcher(self, tintColorAt: toIndex)
    }
}

