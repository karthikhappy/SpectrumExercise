//
//  CompaniesViewModel.swift
//  SpectrumDemo
//
//  Created by nxgdev156 on 06/06/2020.
//  Copyright © 2020 Spectrum. All rights reserved.
//

import Foundation

/// CompaniesViewable helps to refresh the list view
protocol CompaniesViewable: class {
    func refreshCompaniesView()
}

class CompaniesViewModel {
    
    /// All companies in club.
    private var allCompanies: Array<Company>?
    
    /// It contains updated data source to refresh the list view based on user actions filter, sort or all companies.
    private var dataSource: Array<Company>?
    
    /// CompaniesViewable helps to refresh the list view
    public weak var delegate: CompaniesViewable?
    
    /// Makes service reequest to fetch list of compaines from server.
    private lazy var serviceManger: ServiceManager = {
        return ServiceManager()
    }()

    
    /// It always retruns updated data source based on user actions filter or sorting.
    ///
    /// - Return:
    /// list of companies
    public func getDataSource() -> Array<Company>? {
        return dataSource
    }

    /// Fetching all companies from server.
    public func fetchCompanies() {
        serviceManger.fetchClubDetails {[weak self] (companies, error) in
            self?.allCompanies = companies
            self?.updateCompaniesViewDataSource(companies)
        }
    }

    /// Filtering the compamnies based on the user search input. The filiter performed basded on Company Name.
    ///
    /// - Parameters:
    ///   - searchText: text to filter companies with company name
    public func filiterCompanies(_ searchText: String) {
        
        // Display all companies If search text becomes empty.
        guard !searchText.isEmpty else {
            self.updateCompaniesViewDataSource(allCompanies)
            return
        }
        
        guard let companylist = allCompanies else { return }
        let foundCompaines = companylist.filter { ($0.company?.contains(searchText.uppercased()) ?? false) }
        self.updateCompaniesViewDataSource(foundCompaines)
    }

    /// Store and refresh the compaines list view with updated data source.
    ///
    /// - Parameters:
    ///   - companies: list of companies.
    private func updateCompaniesViewDataSource(_ companies: Array<Company>?) {
        dataSource = companies
        self.delegate?.refreshCompaniesView()
    }
}