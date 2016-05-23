//
//  YouTubeVideo.swift
//  Cleverdesk
//
//  Created by Jonas Franz on 15.05.16.
//  Copyright © 2016 Cleverdesk. All rights reserved.
//

import Foundation
import UIKit
import YouTubePlayer

class YouTubeVideo: Component{
    
    var url: NSURL?
    
    func name() -> String {
        return  "YouTubeVideo"
    }
    
    func copy() -> Component {
        return YouTubeVideo()
    }
    
    func fromJSON(json: AnyObject){
        
        print(json)
        let text_s = (json as! Dictionary<NSString, NSString>)["url"]
        
        url = NSURL(string: text_s as! String)
    }
    
    func toUI(mask: CGRect) -> [UIView]? {
        print("Video incomming...")
        print(url)
        if url == nil{
            return []
        }
        
        let dim = CGRectMake(0, 0, 10, 70)
        let videoPlayer = YouTubePlayerView(frame: dim)
        videoPlayer.loadVideoURL(url!)
        
        
        return [videoPlayer]
        
        
    }
}
