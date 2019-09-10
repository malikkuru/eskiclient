//
//  HeadingVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class HeadingVC: BaseTableVC<HeadingVM, UITableViewCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getHeading()
    }
}

extension HeadingVC: HeadingVMOutputProtocol {
    func didGetHeading() {
        tableView.reloadData()
    }
    
    func failedGetHeading(error: Error) {
        print(error)
    }
}

extension HeadingVC {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentCellNumber = indexPath.row
        cell.textLabel?.attributedText = viewModel.entries[currentCellNumber]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.entries.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}