//
//  LocationManager.swift
//  UberSwiftUI
//
//  Created by Songyee Park on 2022/10/05.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
	
	private let locationManager = CLLocationManager()
	static let shared = LocationManager()
	@Published var userLocationCoordinate: CLLocationCoordinate2D?
	
	override init() {
		super.init()
		locationManager.delegate = self 
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}
}

extension LocationManager: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.first else { return }
		self.userLocationCoordinate = location.coordinate
		locationManager.stopUpdatingLocation()
	}
}
