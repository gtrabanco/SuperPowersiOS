//
//  VolumeDetailViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 11/01/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import RxSwift

protocol VolumeDetailViewModelType: class {
    
    /// The button title depends on the volume status
    var buttonTitle: Observable<String> { get }
    
    /// The volume summary
    var summary: VolumeSummary { get }
    
    /// The volume description
    var description: Observable<String> { get }
    
    /// The issues for this volume
    var issues: Observable<[IssueSummary]> { get }
    
    /// Adds or removes the volume
    func addOrRemove()
}

final class VolumeDetailViewModel: VolumeDetailViewModelType {
    
    let summary: VolumeSummary
    
    init(summary: VolumeSummary) {
        self.summary = summary
        self.owned = Variable(self.store.containsVolume(summary.identifier))
    }
    
    func addOrRemove() {
        do {
            if self.owned.value {
                try self.store.removeVolume(self.summary.identifier)
            } else {
                try self.store.addVolume(self.summary)
            }
            
            owned.value = !owned.value
        } catch let error {
            print("Error adding or removing value \(error)")
        }
    }
    
    var buttonTitle: Observable<String> {
        return self.owned.asObservable().map { $0 ? "Remove" : "Add" }
    }
    
    private let session = Session.comicVineSession()
    private let store = VolumeListStore.sharedStore
    private let owned: Variable<Bool>
    
    private(set) lazy var description: Observable<String> = self.session.volumeDetail(self.summary.identifier)
        .map { $0.description ?? "" }
        .catchErrorJustReturn("")
        .startWith("")
        //Make sure the description is delivered in the main thread
        .observeOn(MainScheduler.instance)
        //Strip out the html
        .map { description in
            let data = description.dataUsingEncoding(NSUTF8StringEncoding)
            let options: [String:AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            
            let attributedText = try NSMutableAttributedString(
                data: data!,
                options: options,
                documentAttributes:  nil)
            
            
            return attributedText.string
        }
        .shareReplay(1)
    
    private(set) lazy var issues: Observable<[IssueSummary]> = Observable.just(
        [
            IssueSummary(title: "Lorem fistrum", imageURL: NSURL(string: "http://static.comicvine.com/uploads/scale_small/3/38919/1251093-thanos_imperative_1.jpg")),
            IssueSummary(title: "Quietooor ahorarr", imageURL: NSURL(string: "http://static.comicvine.com/uploads/scale_small/0/9116/1299822-296612.jpg")),
            IssueSummary(title: "Apetecan", imageURL: NSURL(string: "http://static.comicvine.com/uploads/scale_small/5/57845/1333458-cover.jpg")),
            IssueSummary(title: "Rodrigor mamaar", imageURL: NSURL(string: "http://static.comicvine.com/uploads/scale_small/5/56213/1386494-thanos_imperative__4.jpg")),
            IssueSummary(title: "Benemeritaar", imageURL: NSURL(string: "http://static.comicvine.com/uploads/scale_small/3/38919/1452486-thanos_imperative_5.jpg")),
            IssueSummary(title: "Caballo blanco caballo negroorl", imageURL: NSURL(string: "http://static.comicvine.com/uploads/scale_small/3/38919/1503818-thanos_imperative_6.jpg")),
            IssueSummary(title: "Quietooor diodeno", imageURL: NSURL(string: "http://static.comicvine.com/uploads/scale_small/3/39027/4609736-4608485-cgxpqgqw0aao_8t+-+copy.jpg"))
        ]
    )
}
