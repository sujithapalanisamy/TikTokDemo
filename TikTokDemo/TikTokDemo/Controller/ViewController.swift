//
//  ViewController.swift
//  TikTokDemp
//
//  Created by Apple on 19/06/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var videoTableView: UITableView!
    
    private var videoList: [VideoData] = []
    private var currentIndexPath: IndexPath! = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadVideosDataFromJson()
        
        let playerCell = UINib(nibName: "PlayerCell", bundle: nil)
        self.videoTableView.register(playerCell, forCellReuseIdentifier: PlayerCell.identifier)
        self.videoTableView.bounces = false
        self.videoTableView.allowsSelection = false
        self.videoTableView.isScrollEnabled = false
    }
    
    private func loadVideosDataFromJson(){
        if let path = Bundle.main.path(forResource: "video-data", ofType: "json") {
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let videoData = try! JSONDecoder().decode(VideoModel.self, from: data)
                
                self.videoTableView.dataSource = self
                self.videoTableView.delegate = self
                self.videoList = videoData.data
                
                
            } catch let error {
                debugPrint("parse error: \(error.localizedDescription)")
            }
        }
    }
}

//MARK: Button actions
extension ViewController {
    
    @IBAction func swipeToNext(_ sender: UISwipeGestureRecognizer) {
        let nextVideoIndexPath = currentIndexPath.row+1
        if !(nextVideoIndexPath >= videoList.count) {
            currentIndexPath = IndexPath(row: nextVideoIndexPath, section: currentIndexPath.section)
            videoTableView.scrollToRow(at: currentIndexPath, at: .none, animated: true)
        }
    }
    
    
    @IBAction func swipeToBefore(_ sender: UISwipeGestureRecognizer) {
        
        let nextVideoIndexPath = currentIndexPath.row-1
        print(nextVideoIndexPath)
        
        if !(nextVideoIndexPath < 0) {
            currentIndexPath = IndexPath(row: nextVideoIndexPath, section: currentIndexPath.section)
            videoTableView.scrollToRow(at: currentIndexPath, at: .none, animated: true)
        }
    }
    
}


//MARK: Tableview delegates
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.identifier, for: indexPath) as! PlayerCell
        cell.updateData(data: videoList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:  PlayerCell.identifier, for: indexPath) as! PlayerCell
        if let player = cell.player {
            if player.rate != 0 {
                player.pause()
            }
        }
    }
    
}
