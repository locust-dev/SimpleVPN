//
//  ViewController.swift
//  SimpleVPN
//
//  Created by Ilya Turin on 18.11.2021.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Locals
    
    private enum Locals {
        
        static let navigationTitle = "Simple VPN"
        static let mainTitle = "Just press the button and your connection will become private."
        static let powerOnImage = UIImage(named: "powerButtonOn")
        static let powerOffImage = UIImage(named: "powerButtonOff")
    }
    
    
    // MARK: - Properties
    
    private var currentVPNStatus: VPNStatus = .deactivate
    
    private let mainButton = UIButton()
    private let titleAboveMainButton = UILabel()
    private let mainTitle = UILabel()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawSelf()
    }
    
    
    // MARK: - Drawing
    
    private func drawSelf() {
        
        view.backgroundColor = .white
        title = Locals.navigationTitle
        
        mainButton.addTarget(self, action: #selector(activateVPN), for: .touchUpInside)
        mainButton.layer.cornerRadius = 50
        mainButton.setImage(Locals.powerOffImage, for: .normal)
        
        titleAboveMainButton.text = currentVPNStatus.rawValue
        
        mainTitle.text = Locals.mainTitle
        mainTitle.numberOfLines = 0
        mainTitle.textAlignment = .center
        
        view.addSubviewWithAutoLayout(mainButton)
        view.addSubviewWithAutoLayout(titleAboveMainButton)
        view.addSubviewWithAutoLayout(mainTitle)
        
        NSLayoutConstraint.activate([
        
            mainTitle.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor),
            mainTitle.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -50),
            mainTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            mainTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainButton.heightAnchor.constraint(equalToConstant: 100),
            mainButton.widthAnchor.constraint(equalToConstant: 100),
            
            titleAboveMainButton.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor),
            titleAboveMainButton.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 20)
        ])
    }


    // MARK: - Private methods
    
    @objc private func activateVPN() {
    
        currentVPNStatus.toggle()
        titleAboveMainButton.text = currentVPNStatus.rawValue
        
        if currentVPNStatus == .activate {
            
            VPNHandler.shared.initVPNTunnelProviderManager()
            
            mainButton.setImage(Locals.powerOnImage, for: .normal)
        } else {
            
            
            
            
            
            mainButton.setImage(Locals.powerOffImage, for: .normal)
        }
    }
    
}

