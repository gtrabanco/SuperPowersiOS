//
//  VolumeDetailHeaderView.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 11/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit
import Kingfisher

class VolumeDetailHeaderView: UIStackView {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var actionButton: UIButton! {
        didSet {
            actionButton.tintColor = UIColor(named: .ButtonTint)
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor(named: .DarkText)
        }
    }
    
    @IBOutlet private weak var publisherLabel: UILabel! {
        didSet {
            publisherLabel.textColor = UIColor(named: .LightText)
        }
    }
    
    var summary: VolumeSummary? {
        didSet {
            titleLabel.text = summary?.title
            publisherLabel.text = summary?.publisherName
            
            if let imageURL = summary?.imageURL {
                imageView.kf_setImageWithURL(imageURL)
            }
        }
    }
}
