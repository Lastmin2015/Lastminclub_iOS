//
//  ReachabilityManager.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 29.04.2021.
//

import Reachability

public protocol NetworkStatusListener : class {
    func networkStatusDidChange(_ isConnection: Bool)
}

let reachabilityManager = ReachabilityManager.shared

class ReachabilityManager: NSObject {
    static let shared = ReachabilityManager()
    // MARK: - Private variables
    private(set) var reachability: Reachability!
    private var listeners = [NetworkStatusListener]()
    // MARK: - Public variables
    public var reachabilityStatus: Reachability.Connection = .unavailable
    public var isConnection : Bool { return statusConnection() }
    
    // MARK: - Initializers
    private override init() {
        super.init()
        reachability = try! Reachability()
        observeNotification()
        startNotifier()
    }
    
    // MARK: - Notification
    private func observeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
    }
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    @objc private func networkStatusChanged(_ notification: Notification) {
        let reachability = notification.object as! Reachability
        reachabilityStatus = reachability.connection
        listeners.forEach { $0.networkStatusDidChange(isConnection) }
        //debugPrint("Connection: \(reachability.connection)")
    }
    // MARK: - Notifier
    public func startNotifier() {
        do { try reachability.startNotifier() }
        catch { print("Could not start reachability notifier") }
    }
    public func stopNotifier() {
        reachability.stopNotifier()
        removeNotification()
    }
    
    // MARK: - Status
    public func isReachable(completed: (_ isConnection: Bool) -> Void) {
        //print("reachability.connection: \(reachability.connection)")
        completed(reachability.connection != .unavailable)
    }
    
    // MARK: - Listener
    public func addListener(listener: NetworkStatusListener){
        listeners.append(listener)
    }
    public func removeListener(listener: NetworkStatusListener){
        listeners = listeners.filter{ $0 !== listener}
    }
    
    // MARK: - HelperFunctions
    private func statusConnection() -> Bool {
        //return (reachabilityStatus == .wifi) || (reachabilityStatus == .cellular)
        return (reachabilityStatus != .unavailable)
    }
}
