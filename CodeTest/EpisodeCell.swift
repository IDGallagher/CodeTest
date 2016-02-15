//
//  EpisodeCell.swift
//  CodeTest
//
//  Created by Ian Gallagher on 13/02/2016.
//  Copyright © 2016 IGProjects. All rights reserved.
//

import UIKit

class EpisodeCell : BaseTableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    
    static let reuseIdentifier = "EpisodeCell"
    
    var uid:String!
    
    override func initialize() {
        //Watch for episode being updated
        DataManager.shared.updatedEpisode.observeNew { [weak self] uid in
            if self != nil && self!.uid == uid {
                self!.fetchEpisodeAndConfigure(uid)
            }
        }.disposeIn(bnd_bag)
    }
    
    //Called if episode is updated. Fetch episode from realm and configure cell
    func fetchEpisodeAndConfigure(uid:String) {
        if let episode = DataManager.shared.getEpisode(uid) {
            if self.titleLabel.text == "" {
                self.titleLabel.transform = CGAffineTransformMakeTranslation(1000, 0)
                UIView.animateWithDuration(0.6) {
                    self.titleLabel.transform = CGAffineTransformIdentity
                }
            }
            self.configureWithEpisode(episode)
        }
    }
    
    func configureWithEpisode(episode:LarkItem) {
        titleLabel.text = episode.title
        uid = episode.uid
    }
    
}
