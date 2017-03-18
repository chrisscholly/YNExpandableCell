//
//  YNTableView.swift
//  YNExpandableCell
//
//  Created by YiSeungyoun on 2017. 3. 11..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import Foundation
import UIKit

open class YNTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    open var ynDelegate: YNTableViewDelegate? {
        didSet {
            self.delegate = self
            self.dataSource = self

        }
    }
    
    private var expandedIndexPaths = [IndexPath]()
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.initView()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func registerCellsWith(nibNames: [String], and reuseIdentifiers: [String]) {
        self.checkValueIsSame(first: nibNames, second: reuseIdentifiers)
        
        for i in 0..<nibNames.count {
            self.register(UINib(nibName: nibNames[i], bundle: nil), forCellReuseIdentifier: reuseIdentifiers[i])
        }
    }
    
    public func registerCellsWith(cells: [AnyClass], and reuseIdentifiers: [String]) {
        self.checkValueIsSame(first: cells, second: reuseIdentifiers)
        
        for i in 0..<cells.count {
            self.register(cells[i], forCellReuseIdentifier: reuseIdentifiers[i])
        }
    }
    
    public func initData() {
        
    }
    
    internal func checkExpandRowIn(section: Int) -> Int {
        var openedCellCount = 0
        
        for expandedIndexPaths in self.expandedIndexPaths {
            if expandedIndexPaths.section == section {
                openedCellCount += 1
            }
        }
        
        return openedCellCount
    }
    
    //PRAGMA MARK: YNTableView Delegate
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let delegate = self.ynDelegate else { return Int() }
        guard let numberOfSection = delegate.numberOfSections?(in: self) else { return Int() }
        return numberOfSection
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let delegate = self.ynDelegate else { return Int() }
        
        return delegate.tableView(self, numberOfRowsInSection: section) + self.checkExpandRowIn(section: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = self.ynDelegate else { return UITableViewCell() }
        return delegate.tableView(self, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = self.ynDelegate else { return }
        
        if delegate.tableView(self, cellForRowAt: indexPath) is YNExpandableCell {
            let insertIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)

            self.expandedIndexPaths.append(insertIndexPath)
            self.insertRows(at: [insertIndexPath], with: .top)
        }
        //TDDO: Check TableViewCell and if it right, insert indexpath. -> Make internal array for TableView -> Make method for openablecell
    }
    
    private func checkValueIsSame(first: [Any], second: [Any]) {
        if first.count != second.count {
            fatalError("Make first and second value count same")
        }
    }
    
    internal func initView() {
    }
    

}
