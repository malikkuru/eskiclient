//
//  HomeVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import Kanna
import Alamofire

final class HomeVC: BaseTableVC<HomeVM, UITableViewCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getHomepage()
        // FOR GETTING "entries" of "başlık"
        
//                    AF.request("https://eksisozluk.com\(doc.xpath("//li/a").first!["href"]!)").responseString(completionHandler: { (res) in
//                        //ul[@id='entry-item-list']/li
//                        switch res.result {
//                        case .failure(let err):
//                            print("FAIL: \(err)")
//                        case .success(let aa):
//                            if let aaa = try? HTML(html: aa, encoding: .utf8) {
//                                //                                for something in aaa.xpath("//ul[@id='entry-item-list']/li/div") {
//                                //                                    print(something.text!.trimmingCharacters(in: .whitespacesAndNewlines))
//                                //                                }
//                                let html = aaa.xpath("//ul[@id='entry-item-list']/li/div").first!.toHTML!
//                                let data = Data(html.utf8)
//                                if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
//                                    print(attributedString)
//                                }
//                            }
//                        }
//                    })
    }
}

extension HomeVC: HomeVMOutputProtocol {
    func didGetHomepage() {
        tableView.reloadData()
    }
    
    func failedGetHomepage(error: Error) {
        print(error)
    }
}

extension HomeVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.headingNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentCellNumber = indexPath.row
        cell.textLabel?.text = viewModel.headingNames[currentCellNumber]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let link = viewModel.headingLinks[indexPath.row] {
            let nm = NetworkManager()
            nm.getHeading(url: link) { res in
                switch res {
                case .failure(let err):
                    print(err)
                case .success(let val):
                    if let doc = try? HTML(html: val, encoding: .utf8) {
                        for baslik in doc.xpath("//*[@id='entry-item-list']/li") {
                            if let html = baslik.toHTML {
                                let data = Data(html.utf8)
                                if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                                    print(attributedString.string)
                                }
                            }
                            
                        }
                    }
                }
            }
        } else {
            print("Can't get link")
        }
    }
}