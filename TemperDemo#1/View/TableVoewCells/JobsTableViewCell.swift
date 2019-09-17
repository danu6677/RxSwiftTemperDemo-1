//
//  JobsTableViewCell.swift
//  TemperDemo#1
//
//  Created by iTelaSoft on 9/14/19.
//  Copyright © 2019 Danutha. All rights reserved.
//

import UIKit

class JobsTableViewCell: NSObject {
    
    static let TABLE_CELL_TAGS = (title:101, image:100,distance:102,rate:103,working_hours:104);
    
    static func populateTable(_ cell: UITableViewCell, _ data : JobsViewModel?, _ tableViewName:UITableView, _ indxPath: IndexPath){
        configureContent(cell: cell)
        
        //Text Configuration
        Utils.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.title, text: data?.getTitle() ?? "default")
        Utils.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.distance, text: data?.category_distance() ?? "default")
        Utils.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.rate, text: data?.getHourlyRate() ?? "default")
        Utils.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.working_hours, text: data?.start_end_time() ?? "default")
        //Image Configuration with cache
        Utils.setTableCellImageViewImage(cell: cell, imageViewTag: TABLE_CELL_TAGS.image, imageUrlString: data?.getImageUrl() ?? "", tableViewName: tableViewName, indexpath: indxPath)
  
    }
    static func configureContent(cell:UITableViewCell) {
        let label = cell.viewWithTag(TABLE_CELL_TAGS.rate) as! UILabel
        let imageView = cell.viewWithTag(TABLE_CELL_TAGS.image) as! UIImageView
    
        let labelHeight = label.frame.height
        let labelWidth = label.frame.width
        
        let clippingPath = UIBezierPath()
        clippingPath.move(to: CGPoint(x: 0, y: labelHeight))
        
        clippingPath.addCurve(to: CGPoint(x: 2.5 * labelWidth/8, y: 0), controlPoint1: CGPoint(x:
            2 * labelWidth/8, y: labelHeight), controlPoint2: CGPoint(x: labelWidth/8, y: 0))
        clippingPath.addLine(to: CGPoint(x: labelWidth, y: 0))
        clippingPath.addLine(to: CGPoint(x:labelWidth, y:labelHeight))
        clippingPath.close()
        
        let maskForYourPath = CAShapeLayer()
        maskForYourPath.path = clippingPath.cgPath
        label.layer.mask = maskForYourPath
        imageView.layer.cornerRadius = 5
        cell.selectionStyle = .none
    }
}
