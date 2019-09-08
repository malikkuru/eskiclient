//
//  HomeVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation
import Kanna

protocol HomeVMProtocol: BaseVMProtocol {
    func getHomepage()
}

protocol HomeVMOutputProtocol: BaseVMOutputProtocol {
    func didGetHomepage()
    func failedGetHomepage(error: Error)
}

final class HomeVM: HomeVMProtocol {
    weak var delegate: HomeVMOutputProtocol?
    weak var coordinator: Coordinator?
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    private(set) var headingNames = [String?]()
    private(set) var headingCounts = [String?]()
    private(set) var headingLinks = [String?]()
    
    func getHomepage() {
        networkManager.getHomePage { result in
            switch result {
            case .failure(let err):
                self.delegate?.failedGetHomepage(error: err)
            case .success(let val):
                do {
                    let doc = try HTML(html: val, encoding: .utf8)
                    for heading in doc.xpath("//li/a") {
                        self.headingNames.append(heading.xpath("text()[1]").first?.text?.trimmingCharacters(in: .whitespaces))
                        self.headingCounts.append(heading.xpath("small/text()[1]").first?.text?.trimmingCharacters(in: .whitespaces))
                        self.headingLinks.append(heading["href"])
                    }
                    self.delegate?.didGetHomepage()
                } catch {
                    self.delegate?.failedGetHomepage(error: error)
                }
            }
        }
    }
}
