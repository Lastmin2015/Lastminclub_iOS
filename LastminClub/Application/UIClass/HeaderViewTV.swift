//
//  HeaderViewTV.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.04.2021.
//
//https://developer.apple.com/documentation/uikit/views_and_controls/table_views/adding_headers_and_footers_to_table_sections

import UIKit

class HeaderViewTV: UITableViewHeaderFooterView {
    // MARK: Private Properties
    let title = UILabel()
    
    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    func configureContents() {
        contentView.backgroundColor = hexToUIColor("E9E9EE")
        title.font = UIFont(name: "SFProDisplay-Semibold", size: 17)
        title.textColor = hexToUIColor("8A8A8D")
        contentView.addSubview(title)
        
        let margins = contentView.layoutMarginsGuide
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //title.heightAnchor.constraint(equalToConstant: 22),
            title.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
            title.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            //title.topAnchor.constraint(equalTo: margins.topAnchor, constant: 16),
            //title.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0)
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 4)
        ])
    }
}
