//
//  FilmCell.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 9/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import MapKit

class FilmCell: UITableViewCell, Reusable {
    
    var mapView: MKMapView = {
        let map = MKMapView()
        map.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        return map
    }()
    
    var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .darkGray
        titleLabel.font = Constants.avenirRegular
        return titleLabel
    }()
    
    var locationLabel: UILabel = {
        var locationLabel = UILabel()
        locationLabel.numberOfLines = 0
        locationLabel.textAlignment = .center
        locationLabel.textColor = .gray
        locationLabel.font = Constants.avenirHeavy
        return locationLabel
    }()
    
    var dateLabel: UILabel = {
        var dateLabel = UILabel()
        dateLabel.numberOfLines = 0
        dateLabel.textAlignment = .center
        dateLabel.textColor = .darkGray
        dateLabel.font = Constants.avenirMedium
        return dateLabel
    }()
    
    private var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        return separatorView
    }()
    
    private var topSeparatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        return separatorView
    }()
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        selectionStyle = .none
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
            self.mapView.isHidden = !selected
            self.labelStackView.isHidden = selected
        }, completion: { completed in
            self.layoutIfNeeded()
            self.containerStackView.layoutIfNeeded()
            self.labelStackView.layoutIfNeeded()
            self.contentView.layoutIfNeeded()
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addViewToStack()
        setup(container: containerStackView)
        addToContainer()
        setupSeparator()
    }
    
    func setup(with title: String, locationName: String, and year: String) {
        self.titleLabel.text = "Title: \(title)"
        self.locationLabel.text = locationName
        self.dateLabel.text = "Year: \(year)"
        layoutSubviews()
    }
    
    func setup(container: UIStackView) {
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func addViewToStack() {
        labelStackView.addArrangedSubview(locationLabel)
        locationLabel.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor).isActive = true
        labelStackView.addArrangedSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor).isActive = true
        labelStackView.addArrangedSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor).isActive = true
    }
    
    func addToContainer() {
        containerStackView.addArrangedSubview(labelStackView)
        labelStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        labelStackView.centerXAnchor.constraint(equalTo: containerStackView.centerXAnchor).isActive = true
        containerStackView.addArrangedSubview(mapView)
        mapView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: containerStackView.centerXAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = ""
        titleLabel.text = ""
        dateLabel.text = ""
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func updateMap(film: FilmLocation) {
        mapView.addAnnotation(film)
        DispatchQueue.main.async {
            self.mapView.setCenter(film.coordinate, animated: true)
            let latDelta: CLLocationDegrees = 0.004
            let lonDelta: CLLocationDegrees = 0.004
            let span = MKCoordinateSpanMake(latDelta, lonDelta)
            let region = MKCoordinateRegionMake(film.coordinate, span)
            self.mapView.setRegion(region, animated: false)
        }
    }
    
    private func setup(separatorView: UIView) {
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.009).isActive = true
        separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setup(topSeparatorView: UIView) {
        contentView.addSubview(topSeparatorView)
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.009).isActive = true
        topSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        topSeparatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        topSeparatorView.bottomAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    private func setupSeparator() {
        setup(separatorView: separatorView)
        setup(topSeparatorView: topSeparatorView)
        CALayer.setupShadow(view: contentView)
        CALayer.setupShadow(view: separatorView)
        CALayer.setupShadow(view: topSeparatorView)
    }
}
