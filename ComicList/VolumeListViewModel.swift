//
//  VolumeListViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 31/12/15.
//  Copyright © 2015 Guillermo Gonzalez. All rights reserved.
//

import Foundation

/// Represents a volume list view model
protocol VolumeListViewModelType: class {
    
    /// The number of volumes in the list
    var numberOfVolumes: Int { get }
    
    /// Returns the volume item at a given position
    subscript(position: Int) -> VolumeListItem { get }
    
    /// Returns the volume summary at a given position
    subscript(position: Int) -> VolumeSummary { get }
}

final class VolumeListViewModel: VolumeListViewModelType {
    
    var numberOfVolumes: Int {
        // TODO: implement
        return 25
    }
    
    subscript(position: Int) -> VolumeListItem {
        assert(position < numberOfVolumes, "Position out of range")
        
        // TODO: implement
        return VolumeListItem(imageURL: NSURL(string: "http://static.comicvine.com/uploads/scale_small/3/38919/1251093-thanos_imperative_1.jpg"), title: "Some title \(position)")
    }
    
    subscript(position: Int) -> VolumeSummary {
        assert(position < numberOfVolumes, "Position out of range")
        
        // TODO: implement
        return VolumeSummary(identifier: 0, title: "Some title \(position)", imageURL: NSURL(string: "http://static.comicvine.com/uploads/scale_small/3/38919/1251093-thanos_imperative_1.jpg"), publisherName: "Some publisher")
    }
}
