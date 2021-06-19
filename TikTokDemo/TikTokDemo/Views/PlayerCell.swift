//
//  PlayerCell.swift
//  TikTokDemp
//
//  Created by Apple on 19/06/21.
//

import UIKit
import AVFoundation

class PlayerCell: UITableViewCell {

    static var identifier = "PlayerCell"
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playerView: UIView!
    
    var playAction : (() -> ())?
    private var videoURL: URL!
    var player: AVPlayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        thumbnailImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetSelection()
    }

    func resetSelection(){
        self.playButton.isHidden = false
        self.playButton.setImage(UIImage(named: "play"), for: .normal)
        
    }
    
    func updateData(data: VideoData){
        
        if let urlPath =  Bundle.main.url(forResource: data.video, withExtension: "mp4"){
            thumbnailImageView.image = generateThumbnail(path: urlPath)
            videoURL = urlPath
        }
    }

}

//MARK: Gestures actions
extension PlayerCell {
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        
        if player == nil{
            self.thumbnailImageView.image = nil
            self.playButton.isHidden = true
            self.playVideo(path: videoURL)
        }else{
            
            if player.rate != 0 {
                self.playButton.isHidden = false
                self.playButton.setImage(UIImage(named: "pause"), for: .normal)
                player.pause()
            }else{
                self.thumbnailImageView.image = nil
                self.playButton.isHidden = true
                self.playVideo(path: videoURL)
            }
        }
        
    }
}


//MARK: Custom methods
extension PlayerCell {
  
    func playVideo(path: URL) {
        player = AVPlayer(url: path)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.contentView.bounds
        self.playerView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}
