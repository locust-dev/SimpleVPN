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
    }
    
    
    // MARK: - Properties
    
    private var currentVPNStatus: VPNStatus = .deactivate
    
    private let mainButton = UIButton()
    private let titleAboveMainButton = UILabel()
    
    
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
        mainButton.backgroundColor = .lightGray
        
        titleAboveMainButton.text = currentVPNStatus.rawValue
        
        view.addSubviewWithAutoLayout(mainButton)
        view.addSubviewWithAutoLayout(titleAboveMainButton)
        
        NSLayoutConstraint.activate([
        
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
    }
    
}

