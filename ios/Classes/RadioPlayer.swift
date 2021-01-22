/*
 *  RadioPlayer.swift
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 10.01.2021.
 */

import MediaPlayer
import AVKit

class RadioPlayer: NSObject, AVPlayerItemMetadataOutputPushDelegate {
    private var player: AVPlayer!
    private var playerItem: AVPlayerItem!
    private var metadata: Array<String>!

    init(title: String, url: String) {
        super.init()
        let url = URL(string: url)! 

        // Create an AVPlayer.
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player.addObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus), options: [.new], context: nil)
        runInBackground(title)

        // Set metadata handler.
        let metaOutput = AVPlayerItemMetadataOutput(identifiers: nil)
        metaOutput.setDelegate(self, queue: DispatchQueue.main)
        playerItem.add(metaOutput)
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func runInBackground(_ title: String) {
        try? AVAudioSession.sharedInstance().setActive(true)
        try? AVAudioSession.sharedInstance().setCategory(.playback)

        // Control buttons on the lock screen.
        UIApplication.shared.beginReceivingRemoteControlEvents()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: title, ]
        let commandCenter = MPRemoteCommandCenter.shared()

        // Play button.
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.play()
            return .success
        }

        // Pause button.
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.pause()
            return .success
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let observedKeyPath = keyPath, object is AVPlayer, observedKeyPath == #keyPath(AVPlayer.timeControlStatus) else {
            return
        }

        if let statusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
            let status = AVPlayer.TimeControlStatus(rawValue: statusAsNumber.intValue)

            if status == .paused {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "state"), object: nil, userInfo: ["state": false])
            } else if status == .waitingToPlayAtSpecifiedRate {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "state"), object: nil, userInfo: ["state": true])
            }
        }
    }

    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup],
                from track: AVPlayerItemTrack?) {
        guard let title = groups.first?.items.first?.stringValue else {
            return
        }

        metadata = title.components(separatedBy: " - ")
        metadata.append("")

        MPNowPlayingInfoCenter.default().nowPlayingInfo?.updateValue(metadata[0], forKey: MPMediaItemPropertyArtist)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?.updateValue(metadata[1], forKey: MPMediaItemPropertyTitle)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "metadata"), object: nil, userInfo: ["metadata": metadata!])
    }
}
