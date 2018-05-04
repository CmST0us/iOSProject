//
//  BaseStaticTableViewCell.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class BaseStaticTableViewCell: UITableViewCell {
    
    static let identifier = "BaseStaticTableViewCell"
    /// cell 的数据源
    var item: BaseWordItem! {
        didSet {
            fillData()
            changeUI()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func cell(withTableView tableView: UITableView, cellStyle: UITableViewCellStyle) -> BaseStaticTableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BaseStaticTableViewCell
        if cell == nil {
            cell = BaseStaticTableViewCell.init(style: cellStyle, reuseIdentifier: identifier)
        }
        
        return cell!
    }
    
    private func fillData() {
        self.textLabel?.text = self.item.title
        self.detailTextLabel?.text = self.item.subTitle
        self.imageView?.image = self.item.image
    }
    
    private func changeUI() {
        self.textLabel?.font = self.item.titleFont
        self.textLabel?.textColor = self.item.titleColor
        
        self.detailTextLabel?.font = self.item.subTitleFont
        self.detailTextLabel?.textColor = self.item.subTitleColor
        
        self.selectionStyle = .none
        
        if self.item is BaseWordArrowItem {
            self.accessoryType = .disclosureIndicator
            if self.item.operation != nil {
                self.selectionStyle = .default
            }
        } else {
            self.accessoryType = .none
        }

    }
    
}

// MARK: - Lift Cycle Method
extension BaseStaticTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
