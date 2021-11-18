//
//  VPNStatus.swift
//  SimpleVPN
//
//  Created by Ilya Turin on 18.11.2021.
//

enum VPNStatus: String {
    
    case activate = "VPN Activated"
    case deactivate = "VPN Deactivated"
    
    mutating func toggle() {
        
        switch self {
        case .activate: self = .deactivate
        case .deactivate: self = .activate
        }
    }
}
