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
    
    /// The volume summary
    var summary: VolumeSummary { get }
    
    /// The volume description
    var description: Observable<String> { get }
    
    /// The issues for this volume
    var issues: Observable<[IssueSummary]> { get }
}

final class VolumeDetailViewModel: VolumeDetailViewModelType {
    
    let summary: VolumeSummary
    
    init(summary: VolumeSummary) {
        self.summary = summary
    }
    
    private(set) lazy var description: Observable<String> = Observable.just("Lorem fistrum está la cosa muy malar va usté muy cargadoo apetecan diodeno. Fistro quietooor condemor no puedor amatomaa apetecan ahorarr no puedor por la gloria de mi madre sexuarl.")
    
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
