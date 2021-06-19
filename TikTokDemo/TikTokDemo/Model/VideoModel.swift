//
//  VideoModel.swift
//  TikTokDemp
//
//  Created by Apple on 19/06/21.
//

import Foundation

// MARK: - VideoModel
struct VideoModel: Codable {
    let data: [VideoData]
}

// MARK: - VideoData
struct VideoData: Codable {
    let thumbnail, video: String
}
