//
//  NetworkMonitor.swift
//  FlyingPopcornApp
//
//  Created by t2023-m0019 on 12/17/24.
//

import Foundation
import Network
import UIKit

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected:Bool = false
    public private(set) var connectionType:ConnectionType = .unknown
    
    // 연결타입
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    // monotior 초기화
    private init(){
        print("init 호출")
        monitor = NWPathMonitor()
    }
    
    // Network Monitoring 시작
    public func startMonitoring(){
        print("startMonitoring 호출")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            print("path :\(path)")
            
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
            
            if self?.isConnected == true{
                print("연결이된 상태임!")
            }else{
                print("연결 안된 상태임!")
            }
        }
    }
    
    // Network Monitoring 종료
    public func stopMonitoring(){
        print("stopMonitoring 호출")
        monitor.cancel()
    }
    
    private func getConnectionType(_ path:NWPath) {
        print("getConnectionType 호출")
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
            print("wifi에 연결")
            
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
            print("cellular에 연결")
            
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
            print("wiredEthernet에 연결")
            
        } else {
            connectionType = .unknown
            print("unknown ..")
        }
    }
}
