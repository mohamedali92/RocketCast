//
//  ViewController.swift
//  RocketCast
//
//  Created by Odin on 2016-08-27.
//  Copyright © 2016 UBCLaunchPad. All rights reserved.
//

import UIKit
import CoreData
class PodcastController: UIViewController {
    
    var mainView: PodcastView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if AudioEpisodeTracker.isPlaying {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(segueToPlayer) )
        }
    }
    
    fileprivate func setupView() {
        let viewSize = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mainView = PodcastView.instancefromNib(viewSize)
        let listOfPodcasts = DatabaseController.getAllPodcasts()
        mainView?.podcastsToView = listOfPodcasts     
        let updatePodcastsButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateAllPodcasts))
        let addUrlButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(segueToAddUrl))
        let goToItuneWebButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(segueToItuneWeb))

        navigationItem.leftBarButtonItems = [updatePodcastsButton, addUrlButton, goToItuneWebButton]

        view.addSubview(mainView!)
        self.mainView?.viewDelegate = self
        print(listOfPodcasts.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EpisodeController {
            if let podcast = sender as? Podcast {
                let episodes = (podcast.episodes?.allObjects as! [Episode]).sorted(by: { $0.date!.compare($1.date!) == ComparisonResult.orderedDescending })
                destination.episodesInPodcast = episodes
                destination.podcastTitle = podcast.title!
            }
        }
    }
}
extension PodcastController:PodcastViewDelegate {
    
    func segueToAddUrl() {
        performSegue(withIdentifier: Segues.segueFromPodcastListToAddUrl, sender: self)
    }
    
    func segueToEpisode() {
        performSegue(withIdentifier: Segues.segueFromPodcastToEpisode, sender: self)
    }
    func segueToPlayer() {
        performSegue(withIdentifier: Segues.segueFromPodcastListToPlayer, sender: self)
    }
    
    func setSelectedPodcastAndSegue(selectedPodcast: Podcast) {
        performSegue(withIdentifier: Segues.segueFromPodcastToEpisode, sender: selectedPodcast)
    }
    
    func updateAllPodcasts() {
        AudioEpisodeTracker.resetAudioTracker()
        var currentPodcasts =  DatabaseController.getAllPodcasts()
        while (!currentPodcasts.isEmpty) {
            if let podcast = currentPodcasts.popLast() {
                if let rssFeedURL = podcast.rssFeedURL {
                    
                    DatabaseController.deletePodcast(podcastTitle: podcast.title!)
                    XMLParser(url:rssFeedURL)
                }
            }
        }
        navigationItem.rightBarButtonItem = nil
        let listOfPodcasts = DatabaseController.getAllPodcasts()
        mainView?.podcastsToView = listOfPodcasts
        self.mainView?.podcastList.reloadData()
    }
    
    func segueToItuneWeb() {
        performSegue(withIdentifier: Segues.segueToItuneWeb, sender: self)
    }
}
