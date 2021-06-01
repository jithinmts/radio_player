/*
 *  SwiftRadioPlayerPlugin.swift
 *
 *  Created by Ilya Chirkunov <xc@yar.net> on 10.01.2021.
 */

import Flutter
import UIKit

public class SwiftRadioPlayerPlugin: NSObject, FlutterPlugin {
    private var player = RadioPlayer()
    public static var stateEventSink: FlutterEventSink?
    public static var metadataEventSink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "radio_player", binaryMessenger: registrar.messenger())
        let instance = SwiftRadioPlayerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        let stateChannel = FlutterEventChannel.init(name: "radio_player/stateEvents", binaryMessenger: registrar.messenger())
        stateChannel.setStreamHandler(StateStreamHandler())
        let metadataChannel = FlutterEventChannel.init(name: "radio_player/metadataEvents", binaryMessenger: registrar.messenger())
        metadataChannel.setStreamHandler(MetadataStreamHandler())
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Array<Any>

        switch call.method {
            case "set":
                guard let args = args else {
                    return
                }
                player.setMediaItem(args[0] as! String, args[1] as! String)
            case "play":
                player.play()
            case "pause":
                player.pause()
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}

/** Handler for playback state changes, passed to setStreamHandler() */
class StateStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        NotificationCenter.default.addObserver(self, selector: #selector(onRecieve(_:)), name: NSNotification.Name(rawValue: "state"), object: nil)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    // Notification receiver for playback state changes, passed to addObserver()
    @objc private func onRecieve(_ notification: Notification) {
        if let metadata = notification.userInfo!["state"] {
            eventSink?(metadata)
        }
    }
}

/** Handler for new metadata, passed to setStreamHandler() */
class MetadataStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        NotificationCenter.default.addObserver(self, selector: #selector(onRecieve(_:)), name: NSNotification.Name(rawValue: "metadata"), object: nil)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    // Notification receiver for new metadata, passed to addObserver()
    @objc private func onRecieve(_ notification: Notification) {
        if let metadata = notification.userInfo!["metadata"] {
            eventSink?(metadata)
        }
    }
}
