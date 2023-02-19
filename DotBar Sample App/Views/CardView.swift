//
//  CardView.swift
//  DotBar Sample App
//
//  Created by Kishore Narang on 2023-02-17.
//

import UIKit
import DotBar

class CardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var dotBar: DotBar = {
        let dotBar = DotBar()
        dotBar.progressBarHeight = 10
        
        // colors
        // inactive
        dotBar.dotColor = .systemGray6
        dotBar.dotActiveColor = .systemGreen
        dotBar.dotIconColor = .black
        dotBar.dotIconActiveColor = .white
        dotBar.labelColor = .white
        dotBar.strings = [
            "Started",
            "In Progress",
            "On Hold",
            "Completed"
        ]
        dotBar.dots = 4
        dotBar.hideFirst = false
        dotBar.leftPadding = 40
        dotBar.hideLast = false
        dotBar.rightPadding = 40
        dotBar.dotImage = UIImage(systemName: "circle")!
        
        return dotBar
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cardBackground") ?? UIImage()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let progressViewHeight: CGFloat = 30.0
    let progressViewMargin: CGFloat = 0
    
    private func setupUI() {
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 12
        
        // Set the shadow properties
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        self.addSubview(imageView)
        self.addSubview(dotBar)
        
        dotBar.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        
        dotBar.translatesAutoresizingMaskIntoConstraints = false
        dotBar.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        dotBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressViewMargin).isActive = true
        dotBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -progressViewMargin).isActive = true
        dotBar.heightAnchor.constraint(equalToConstant: progressViewHeight).isActive = true
        dotBar.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        imageView.clipsToBounds = true
        
        dotBar.layoutIfNeeded()
        
        
        //self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardTapped)))
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        
    }
    var progress: Int = 0
    @objc private func cardTapped() {
        progress -= 1
        progress = progress <= 0 ? 0 : progress >= 5 ? 5 : progress
        UIView.animate(withDuration: 1.0, animations: { [self] in 
            //self.dotBar.setProgress(toDot: progress)
        })
    }
    
    @objc private func doubleTap() {
        progress += 1
        progress = progress <= 0 ? 0 : progress >= 5 ? 5 : progress
        UIView.animate(withDuration: 1.0, animations: { [self] in
            self.dotBar.setProgress(toDot: progress)
        })
    }
    

}
