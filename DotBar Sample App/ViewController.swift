//
//  ViewController.swift
//  DotBar Sample App
//
//  Created by Kishore Narang on 2023-02-17.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var cardView: CardView = {
        let cardView = CardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    lazy var textLabel: UILabel = {
       let label = UILabel()
        label.text = "Welcome to Dotbar"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle, compatibleWith: nil)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        self.view.addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        textLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        
        self.view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20).isActive = true
        cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    
}

