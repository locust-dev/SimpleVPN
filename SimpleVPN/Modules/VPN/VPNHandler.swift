//
//  VPNHandler.swift
//  SimpleVPN
//
//  Created by Ilya Turin on 18.11.2021.
//

import Foundation
import NetworkExtension

final class DefaultVPNManager: VPNRepository {
    
    var selectedVPN: String = ""
    
    var activatedVPN: String = ""
    
    
    func loadPreferences(completion: @escaping () -> ()) {
        
        #if targetEnvironment(simulator)
        
        #else
        manager.loadFromPreferences { error in
                    assert(error == nil, "Failed to load preferences \(error?.localizedDescription ?? "Unknown Error")")
                    completion()
                }
        #endif
        
    }
    
    private func
        save(account: VPNAccount, completion: @escaping () -> Void) {
        #if targetEnvironment(simulator)
            assert(false, "I'm afraid you can not connect VPN in simulators.")
        #endif
        
        var pt: NEVPNProtocol
        
        switch account.type {
        case .IPSec:
            let p = NEVPNProtocolIPSec()
            p.useExtendedAuthentication = true
            p.localIdentifier = account.localID ?? "VPN"
            p.remoteIdentifier = account.remoteID
            if account.pskEnabled {
                p.authenticationMethod = .sharedSecret
                p.sharedSecretReference = account.getPSKRef()
            } else {
                p.authenticationMethod = .none
            }
            pt = p
            break
        case .IKEv2:
            let p = NEVPNProtocolIKEv2()
            p.useExtendedAuthentication = true
            p.localIdentifier = account.localID
            p.remoteIdentifier = account.remoteID
            
            if (account.pskEnabled) {
                p.authenticationMethod = .sharedSecret
                p.sharedSecretReference = account.getPSKRef()
                p.passwordReference = account.getPasswordRef()
                
            } else {
                p.authenticationMethod = .none
            }
            
            p.deadPeerDetectionRate = .medium
            pt = p
            break
        }
        
        pt.disconnectOnSleep = false
        pt.serverAddress = account.server
        
        pt.username = account.account
        pt.passwordReference = account.getPasswordRef()
        
        manager.localizedDescription = "SECURE VPN"
        manager.protocolConfiguration = pt
        manager.isEnabled = true
        
        configOnDemand()
        
        manager.saveToPreferences { error in
            if let err = error {
                print("Failed to save Preferences: \(err.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    func connect() {
//        let conf = Configuration(server: "uk.freeikev2vpn.com", account: "freeikev2vpn.com", password: "free", description: "Free VPN UK", remoteID: "uk.freeikev2vpn.com", localID: nil)
         let conf = Configuration(server: "144.202.9.42",  country: "usa", pro: true, account: "myusername", password: "hSyeI1H8Wsybb5qDk5abBrJ7LCu3bPbJrax9aFG77FiiJZu3eUepLwvg9pjjEL3", psk: "SEXapPAm5x5OXktAzes9nxE3NvilpmIH1orpE2cIzgfWRZgQDYZ1Wm3thlfXXwn", description: "Vultr USA", remoteID: "securevpn.com.myserver", localID: nil)
       conf.saveToDefaults()
        loadPreferences { [weak self] in
            self?.save(account: conf) {
                do {
                    try self?.manager.connection.startVPNTunnel()
                } catch  NEVPNError.configurationInvalid {
                    print("Invalid Config")
                }
                catch NEVPNError.configurationDisabled{
                    print("Config disabled")
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                    NotificationCenter.default.post(
                        name: NSNotification.Name.NEVPNStatusDidChange,
                        object: nil
                    )
                }
            }
        }
    }
    
    func saveAndConnect(_ account: VPNAccount) {

        save(config: account) { [weak self] in
            _ = self?.connectVPN()
        }
    }
    
    func configOnDemand() {
        
    }
    
    func disconnect() {
        manager.connection.stopVPNTunnel()
    }
    
    func removeProfile() {
        manager.removeFromPreferences { [weak self] _ in
            self?.manager.removeFromPreferences { _ in
                
            }
        }
    }
    
    func save(config: VPNAccount, completion: @escaping () -> Void) {
        loadPreferences { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.save(account: config, completion: completion)
        }
    }
    
    public func saveAndConnect(_ config: Configuration) {
        save(config: config) { [weak self] in
            guard let self = self else { return }
            _ = self.connectVPN()
        }
    }
    
    func connectVPN() -> Bool {
        debugPrint("!!!!! Establishing Connection !!!!!")
        do {
            try self.manager.connection.startVPNTunnel()
            return true
        } catch NEVPNError.configurationInvalid {
            debugPrint("Failed to start tunnel (configuration invalid)")
        } catch NEVPNError.configurationDisabled {
            debugPrint("Failed to start tunnel (configuration disabled)")
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            NotificationCenter.default.post(name: Notification.Name.NEVPNStatusDidChange, object: nil)
            return false
        }
        
        return false
    }
}
