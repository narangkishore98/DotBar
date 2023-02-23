//
//  DotBar.swift
//  DotBar
//
//  Created by Kishore Narang on 2023-02-17.
//

import Foundation


import UIKit

@IBDesignable
/// DotBar is a ProgressBar that contains dots.
public class DotBar: UIView {
    
    /**
     DotBar contains multiple dots and multiple progressbars each dot is connected with one individual dot.
     */
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func layoutSubviews() {
        setupView()
    }
    
    
    private func setupView() {
        subviews.forEach({$0.removeFromSuperview()})
        self.backgroundColor = .clear
        progressBars = []
        dotViews = []
        labels = []
        for _ in 0...Int(_dots) {
            progressBars.append(progressBar())
        }
        dotViews = makeDots()
        labels = makeLabels()
        if(dotViews.count != progressBars.count - 1) && dotViews.count != labels.count {
            fatalError("Dots size and progress bars size has a mismatch")
        }
        for progressBar in progressBars {
            addSubview(progressBar)
        }
        for dot in dotViews {
            addSubview(dot)
        }
        for label in labels {
            addSubview(label)
        }
        
        setupLayout()
        
    }
    
    private func setupLayout() {
        
        let firstProgressBar = progressBars[0]
        let lastProgressBar = progressBars[progressBars.count - 1]
        firstProgressBar.translatesAutoresizingMaskIntoConstraints = false
        lastProgressBar.translatesAutoresizingMaskIntoConstraints = false
        
        // First Progress Bar's Constraints Set
        firstProgressBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        firstProgressBar.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        firstProgressBar.heightAnchor.constraint(equalToConstant: _progressBarHeight).isActive = true
        
        if hideFirst {
            firstProgressBar.widthAnchor.constraint(equalToConstant: leftPadding).isActive = true
        } else {
            firstProgressBar.widthAnchor.constraint(equalToConstant: progressBarWidth).isActive = true
        }
        
        
        
        // After activating all the constraints, let's do the same for `lastProgressBar`
        
        lastProgressBar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        if hideLast {
            lastProgressBar.widthAnchor.constraint(equalToConstant: rightPadding).isActive = true
        }
        
        // hide progress bars if not needed.
        firstProgressBar.isHidden = hideFirst
        lastProgressBar.isHidden = hideLast
        
        setupLayoutForDots()
        //setupLayoutForOddDots()
    }
    
    func setupLayoutForDots() {
        for index in 1..<progressBars.count {
            
            // Constraints for dotViews[index-1]
            dotViews[index-1].translatesAutoresizingMaskIntoConstraints = false
            dotViews[index-1].leadingAnchor.constraint(equalTo: progressBars[index-1].trailingAnchor, constant: -5).isActive = true
            dotViews[index-1].trailingAnchor.constraint(equalTo: progressBars[index].leadingAnchor, constant: 5).isActive = true
            dotViews[index-1].centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            dotViews[index-1].heightAnchor.constraint(equalToConstant: dotSize).isActive = true
            dotViews[index-1].widthAnchor.constraint(equalToConstant: dotSize).isActive = true
            
            // Constraints for labels[index-1]
            labels[index-1].translatesAutoresizingMaskIntoConstraints = false
            labels[index-1].centerXAnchor.constraint(equalTo: dotViews[index-1].centerXAnchor).isActive = true
            labels[index-1].widthAnchor.constraint(equalToConstant: _textBoxMaxWidth).isActive = true
            labels[index-1].topAnchor.constraint(equalTo: dotViews[index-1].bottomAnchor, constant: 10).isActive = true
            
            // Constraints for progressBars[index]
            progressBars[index].translatesAutoresizingMaskIntoConstraints = false
            progressBars[index].centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            progressBars[index].widthAnchor.constraint(equalToConstant: progressBarWidth).isActive = true
            progressBars[index].heightAnchor.constraint(equalToConstant: _progressBarHeight).isActive = true
            if index == _progressBars - 1 {
                progressBars[index].trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            }
            
            
            
        }
    }
    
    // Function to set Progress from value 0 to 100
    // The value will be in range [0-100] any below or above value will be defaulted to nearest valid range.
    private func setProgress(to value: CGFloat) {
        
        // TODO: - Fix this later in next version. 
        self.layoutIfNeeded()
        // progress value from 0 to 100
        let progressValue = value <= 0 ? 0 : (value >= 100 ? 100 : value)
        
        // width of the dotbar to draw.
        var drawTo = (width - CGFloat(_dots) * dotSize) * progressValue / 100
        
        // Number of progress bars to draw full.
        let fullProgressBarsToDraw = Int(drawTo / progressBarWidth) >= _progressBars ? _progressBars - 1 : Int(drawTo / progressBarWidth)
        drawTo -= CGFloat(fullProgressBarsToDraw) * progressBarWidth
        for index in 0..<fullProgressBarsToDraw {
            animate(progressBar: progressBars[index], to: 1.0)
            if index < _dots {
                dotViews[index].mode = .active
            }
        }
        animate(progressBar: progressBars.filter({$0.progress == 0}).first, to: drawTo / 100)
        
    }
    

    /// A method to draw the progress bar upto the `dotNumber`
    ///
    ///  Function to set progress from 1 to n dots.
    ///  The value will be in range [1-{number of dots}] any below or above value will be defaulted to the nearest valid range.
    public func setProgress(toDot dotNumber: Int) {
        // progress value to 1 to _dots
        let progressValue = dotNumber <= 1 ? 1 : (dotNumber >= _dots ? _dots : dotNumber)
        
        for index in 0 ..< progressValue {
            progressBars[index].progress = 1.0
            if index < _dots {
                dotViews[index].mode = .active
            }
            if index == _dots - 1 {
                animate(progressBar: progressBars[_dots], to: 1.0)
            }
        }
    }
    
    /// A method to draw the specific progressBar given by `progressBarIndex` to a specific value from 1 to 100
    ///
    ///  First parameter is the progressBarIndex which is the number of progress bar to draw - 1
    ///  Function to set progress from 1 to 100 dots.
    ///  The value will be in range [1-{number of dots}] any below or above value will be defaulted to the nearest valid range.
    public func setProgress(for progressBarIndex: Int, to value: CGFloat) {
        // progress bar to draw, if out of the range choose the first or last value.
        let progressBarIndexToDraw = progressBarIndex <= 0 ? 0 : (progressBarIndex >= (_progressBars - 1 ) ? (_progressBars - 1) : progressBarIndex)
        // progress value from 0 to 100
        let progressValue = value <= 0 ? 0 : (value >= 100 ? 100 : value)
        
        //animate(progressBar: progressBars[progressBarIndexToDraw], to: progressValue / 100)
        progressBars[progressBarIndexToDraw].progress = Float(value)
        if progressBarIndexToDraw >= 1 {
            // Means second progress bar or so.
            // Activate the left connected dotBar
            dotViews[progressBarIndexToDraw-1].mode = .active
        }
        if progressBarIndexToDraw < _dots && progressValue >= 100 {
            dotViews[progressBarIndexToDraw].mode = .active
        }
        
    }
    
    /// Resets the progresBar to 0.
    ///
    /// This function resets the progress bar to 0. You can start the progress with `setProgress` methods
    public func resetProgress() {
        progressBars.forEach({ $0.progress = 0 })
        dotViews.forEach({ $0.mode = .inactive })
    }
    
    /// Redraws the progress bar.
    ///
    /// Sometimes, when required you can re-draw the progress bar after all of your views are drawn, you can call this method to make sure that the progressbar is drawn successfully.
    public func makeProgressBar() {
        setupView()
    }
    // MARK: - Configs
    // (Type - CGFloat) Number of Dots in View Default to 5.
    private var _dots: Int = 5
    //(Type - Int)  Number of Progress Bars in View default set to 6.
    private var _progressBars: Int {
        get {
            return _dots + 1
        }
    }
    // (Type - CGFloat) progress bar height.
    private var _progressBarHeight: CGFloat = 5
    // (Type - CGFloat) text box width.
    private var _textBoxMaxWidth: CGFloat = 60.0
    
    // MARK: - Views & Data
    // (Type - [String]) Dot Strings. Default to Empty Array.
    private var _strings: [String] = []
    // (Type - [UIImage]) Number of Icons Default to Empty Array.
    private var _icons: [UIImage] = []
    // (Type [UIProgressView]) Progress Bars
    private var progressBars: [UIProgressView] = []
    // (Type = UIView) Dot Views
    private var dotViews: [DotView] = []
    // (Type = UILabel) Text Labels
    private var labels: [UILabel] = []
    // (Type = UIImage) Dot Image
    private var _dotImage: UIImage = UIImage()
    // Main Stack View.
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    // (Type - UIProgressView) first ProgressBar in all bars.
    private lazy var firstProgressBar: UIProgressView? = {
        return progressBars.first
    }()
    private lazy var lastProgressBar: UIProgressView? = {
        return progressBars.last
    }()
    
    // MARK: - Design System.
    // Color for Progress Bar.
    var progressBarBackgroundColor: UIColor { dotColor }
    var progressBarTrackColor: UIColor { dotActiveColor }
    // Color for Dots
    /// Color of the dot and progress bar, when it is inactive
    public var dotColor: UIColor = .orange
    /// Color of  the dot and progress bar when it is active.
    public var dotActiveColor: UIColor = .white
    /// Icon color when inactive.
    public var dotIconColor: UIColor = .white
    /// Icon color when active.
    public var dotIconActiveColor: UIColor?
    // Color for text
    public var labelColor: UIColor = .black
    // Dot Size
    var dotSize: CGFloat { _progressBarHeight * 3 }
    // Booleans to hide first or last view.
    public var hideFirst: Bool = false
    // true if first progress should be hidden
    public var hideLast: Bool = false
    // true if last progress should be hidden
    public var firstPrefilled: Bool = false // true if first progress should be prefilled half.
    var firstPrefilledValue: CGFloat = 10 // firstPrefilledValue default to be 10.
    //If hidden, default to `firstProgressFlex`
    public var leftPadding: CGFloat = 0.0
    public var rightPadding: CGFloat = 0.0
    
    
    @IBInspectable
    public var dots: Int {
        set {
            _dots = newValue
        }
        get {
            return _dots
        }
    }
    @IBInspectable
    public var dotImage: UIImage {
        set {
            _dotImage = newValue
        }
        get {
            return _dotImage
        }
    }
    public var progressBarHeight: CGFloat {
        set {
            _progressBarHeight = newValue
        }
        get {
            return _progressBarHeight
        }
    }
    public var textBoxMaxWidth: CGFloat {
        set {
            _textBoxMaxWidth = newValue
        }
        get {
            return _textBoxMaxWidth
        }
    }
    public var strings: [String] {
        set {
            _strings = newValue
        }
        get {
            if _strings.isEmpty {
                return ["1", "2", "3", "4", "5"]
            }
            return _strings
        }
    }
    public var icons: [UIImage] {
        set {
            _icons = newValue
        }
        get {
            return _icons
        }
    }
    
    private var _width: CGFloat = 0
    
    var width: CGFloat {
        get {
            return _width == 0 ? self.bounds.width : _width
        }
        set {
            _width = newValue
        }
    }
    
    private var progressBarWidth: CGFloat {
        var numberOfProgressBars = _progressBars
        var widthToDivide = width
        if hideFirst {
            numberOfProgressBars -= 1
            widthToDivide -= leftPadding
        }
        if hideLast {
            numberOfProgressBars -= 1
            widthToDivide -= rightPadding
        }
        let originalWidth =  abs((widthToDivide - CGFloat(_dots) * dotSize) / CGFloat(numberOfProgressBars)) + 10
        
        return originalWidth
    }
    
    private func animate(progressBar: UIProgressView?, to value: CGFloat) {
        UIView.animate(withDuration: 1) {
            progressBar?.progress = Float(value)
        }
    }
    
}

// MARK: - View Makers
extension DotBar {
    private func progressBar() -> UIProgressView {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.bounds = CGRect(x: 0, y: 0, width: progressBarWidth, height: _progressBarHeight)
        progressBar.sizeToFit()
        progressBar.tintColor = progressBarBackgroundColor
        progressBar.backgroundColor = progressBarBackgroundColor
        progressBar.progressTintColor = progressBarTrackColor
        return progressBar
    }
    
    private func makeLabels() -> [UILabel] {
        var labels: [UILabel] = []
        for index in 0..<Int(_dots) {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = labelColor
            label.textAlignment = .center
            label.numberOfLines = 0
            label.lineBreakMode = .byCharWrapping
            label.font = .preferredFont(forTextStyle: .caption2, compatibleWith: nil)
            label.text = strings[index]
            labels.append(label)
        }
        return labels
    }
    
    private func makeDots() -> [DotView] {
        var dots: [DotView] = []
        for _ in 0..<Int(_dots) {
            let dot = DotView(size: dotSize)
            dot.dotColor = dotColor
            dot.dotActiveColor = dotActiveColor
            dot.dotIconColor = dotIconColor
            dot.dotIconActiveColor = dotIconActiveColor
            dot.setImage(to: _dotImage)
            dot.mode = .inactive
            dots.append(dot)
        }
        return dots
    }
}


fileprivate final class DotView: UIView {
    
    enum Mode {
        case active, inactive
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var size: CGFloat?
    private var imageView: UIImageView?
    private var image: UIImage?
    
    // Color for Dots
    var dotColor: UIColor = .black
    var dotActiveColor: UIColor?
    var dotIconColor: UIColor = .white
    var dotIconActiveColor: UIColor?
    var mode: DotView.Mode = .inactive {
        didSet {
            imageView?.image = image?.withRenderingMode(.alwaysTemplate)
            imageView?.tintColor = mode == .inactive ? dotIconColor : dotIconActiveColor ?? dotColor
            self.backgroundColor = mode == .inactive ? dotColor : dotActiveColor ?? dotIconColor
            self.layer.borderColor = (mode == .inactive ? dotColor : dotActiveColor ?? dotIconColor).cgColor
        }
    }
    
    convenience init(size: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        self.size = size
        self.layer.borderColor = dotColor.cgColor
        self.backgroundColor = mode == .inactive ? dotColor : dotActiveColor ?? dotIconColor
        self.layer.cornerRadius = size / 2
        imageView = UIImageView()
        addSubview(imageView ?? UIImageView())
    }
    override func layoutSubviews() {
        
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.heightAnchor.constraint(equalToConstant: (self.size ?? 0) / 2).isActive = true
        imageView?.widthAnchor.constraint(equalToConstant: (self.size ?? 0) / 2).isActive = true
        imageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
    }
    
    func setImage(to image: UIImage) {
        self.image = image.withRenderingMode(.alwaysTemplate)
        imageView?.image = image.withRenderingMode(.alwaysTemplate)
        imageView?.tintColor = mode == .inactive ? dotIconColor : dotIconActiveColor ?? dotColor
        
    }
}
