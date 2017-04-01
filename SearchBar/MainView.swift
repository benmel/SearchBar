//
//  MainView.swift
//  SearchBar
//
//  Created by Ben Meline on 11/16/15.
//  Copyright © 2015 Ben Meline. All rights reserved.
//

import UIKit
import PureLayout

class MainView: UIView {
    
    private var searchBar: UISearchBar!
    private var searchButton: UIButton!
    private var resultsTable: UITableView!
    
    private let searchButtonHeight: CGFloat = 60
    private let searchButtonWidth: CGFloat = 200
    
    private let searchBarStartingAlpha: CGFloat = 0
    private let searchButtonStartingAlpha: CGFloat = 1
    private let tableStartingAlpha: CGFloat = 0
    private let searchBarEndingAlpha: CGFloat = 1
    private let searchButtonEndingAlpha: CGFloat = 0
    private let tableEndingAlpha: CGFloat = 1
    
    private let searchButtonStartingCornerRadius: CGFloat = 20
    private let searchButtonEndingCornerRadius: CGFloat = 0

    private var searchBarTop = false
    private var searchButtonWidthConstraint: NSLayoutConstraint?
    private var searchButtonEdgeConstraint: NSLayoutConstraint?
    private var didSetupConstraints = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // MARK: - Initialization
    
    func setupViews() {
        setupSearchBar()
        setupSearchButton()
        setupResultsTable()
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar.newAutoLayoutView()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.alpha = searchBarStartingAlpha
        addSubview(searchBar)
    }
    
    func setupSearchButton() {
        searchButton = UIButton(type: .Custom)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: "searchClicked:", forControlEvents: .TouchUpInside)
        searchButton.setTitle("Search", forState: .Normal)
        searchButton.backgroundColor = .blueColor()
        searchButton.layer.cornerRadius = searchButtonStartingCornerRadius
        addSubview(searchButton)
    }
    
    func setupResultsTable() {
        resultsTable = UITableView.newAutoLayoutView()
        resultsTable.alpha = tableStartingAlpha
        addSubview(resultsTable)
    }
    
    // MARK: - Layout
    
    override func updateConstraints() {
        if !didSetupConstraints {
            searchBar.autoAlignAxisToSuperviewAxis(.Vertical)
            searchBar.autoMatchDimension(.Width, toDimension: .Width, ofView: self)
            searchBar.autoPinEdgeToSuperviewEdge(.Top)
            
            searchButton.autoSetDimension(.Height, toSize: searchButtonHeight)
            searchButton.autoAlignAxisToSuperviewAxis(.Vertical)
            
            resultsTable.autoAlignAxisToSuperviewAxis(.Vertical)
            resultsTable.autoPinEdgeToSuperviewEdge(.Leading)
            resultsTable.autoPinEdgeToSuperviewEdge(.Trailing)
            resultsTable.autoPinEdgeToSuperviewEdge(.Bottom)
            resultsTable.autoPinEdge(.Top, toEdge: .Bottom, ofView: searchBar)
            
            didSetupConstraints = true
        }
        
        searchButtonWidthConstraint?.autoRemove()
        searchButtonEdgeConstraint?.autoRemove()
        
        if searchBarTop {
            searchButtonWidthConstraint = searchButton.autoMatchDimension(.Width, toDimension: .Width, ofView: self)
            searchButtonEdgeConstraint = searchButton.autoPinEdgeToSuperviewEdge(.Top)
        } else {
            searchButtonWidthConstraint = searchButton.autoSetDimension(.Width, toSize: searchButtonWidth)
            searchButtonEdgeConstraint = searchButton.autoAlignAxisToSuperviewAxis(.Horizontal)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - User Interaction
    
    func searchClicked(sender: UIButton!) {
        showSearchBar(searchBar)
    }
    
    // MARK: - Helpers
    
    func showSearchBar(searchBar: UISearchBar) {
        searchBarTop = true
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
        
        UIView.animateWithDuration(0.3,
            animations: {
                searchBar.becomeFirstResponder()
                self.layoutIfNeeded()
            }, completion: { finished in
                UIView.animateWithDuration(0.2,
                    animations: {
                        searchBar.alpha = self.searchBarEndingAlpha
                        self.resultsTable.alpha = self.tableEndingAlpha
                        self.searchButton.alpha = self.searchButtonEndingAlpha
                        self.searchButton.layer.cornerRadius = self.searchButtonEndingCornerRadius
                    }
                )
            }
        )
    }
    
    func dismissSearchBar(searchBar: UISearchBar) {
        searchBarTop = false
        
        UIView.animateWithDuration(0.2,
            animations: {
                searchBar.alpha = self.searchBarStartingAlpha
                self.resultsTable.alpha = self.tableStartingAlpha
                self.searchButton.alpha = self.searchButtonStartingAlpha
                self.searchButton.layer.cornerRadius = self.searchButtonStartingCornerRadius
            }, completion:  { finished in
                self.setNeedsUpdateConstraints()
                self.updateConstraintsIfNeeded()
                UIView.animateWithDuration(0.3,
                    animations: {
                        searchBar.resignFirstResponder()
                        self.layoutIfNeeded()
                    }
                )
            }
        )
    }
}

extension MainView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        dismissSearchBar(searchBar)
    }
}
