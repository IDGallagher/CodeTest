//
//  DetailViewController.swift
//  CodeTest
//
//  Created by Ian Gallagher on 13/02/2016.
//  Copyright © 2016 IGProjects. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var synopsisLabel:UILabel!
    @IBOutlet weak var imageView:UIImageView!

    var uid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Watch for episode being updated
        DataManager.shared.updatedEpisode.observeNew { [weak self] uid in
            if self != nil && self!.uid == uid {
                self!.fetchEpisodeAndConfigure(uid)
            }
        }.disposeIn(bnd_bag)
        
        if let uid = uid {
            fetchEpisodeAndConfigure(uid)
        }
    }

    //Fetch episode from realm and configure view
    func fetchEpisodeAndConfigure(uid:String) {
        if let episode = DataManager.shared.getEpisode(uid) {
            titleLabel.text = episode.title
            if episode.synopsis != "" {
                synopsisLabel.text = episode.synopsis
            } else {
                synopsisLabel.text = "No synopsis..."
            }
            if episode.imageFileUrl != "" {
                if let imageURL = NSURL(string: episode.imageFileUrl) {
                    imageView.kf_setImageWithURL(imageURL, placeholderImage: nil, optionsInfo: [.Transition(ImageTransition.Fade(1))])
                }
            }
        }
    }
}

