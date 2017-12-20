//
//  TableViewController.swift
//  CYUtilProjectSwift
//
//  Created by Jasper on 14/12/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

@objc public protocol SimpleTableViewProtocol: UITableViewDataSource, UITableViewDelegate {
    
    var sectionCount: Int { get }
    var sectionTitles: [Int: String]? { get }
    var contents: [[ViewModelProtocol]]? { get }
    
    @objc func tableView(_ tableView: UITableView, reuseIdentifierForRowAt indexPath: IndexPath) -> String
}

extension SimpleTableViewProtocol {
    
//    // MARK: - Table view data source
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return sectionCount
//    }
//    
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return contents?[section].count ?? 0
//    }
//    
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if let viewModel = contents?[indexPath.section][indexPath.row] {
//            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier, for: indexPath)
//            cell.contents = viewModel
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
//            cell.viewModel = nil
//            return cell
//        }
//    }
//    
//    // MARK: - Table view delegate
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let height = 
//    }
}
