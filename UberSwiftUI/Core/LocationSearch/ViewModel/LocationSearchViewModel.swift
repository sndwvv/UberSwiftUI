//
//  LocationSearchViewModel.swift
//  UberSwiftUI
//
//  Created by Songyee Park on 2022/10/06.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
	
	// MARK: - Properties
	
	@Published var results = [MKLocalSearchCompletion]()
	@Published var selectedUberLocation: UberLocation?
	@Published var pickupTime: String?
	@Published var dropoffTime: String?
	
	private var searchCompleter = MKLocalSearchCompleter()
	
	var queryFragment: String = "" {
		didSet {
			searchCompleter.queryFragment = queryFragment
		}
	}
	
	var userLocationCoordinate: CLLocationCoordinate2D?
	
	// MARK: - Lifecycle
	
	override init() {
		super.init()
		searchCompleter.delegate = self
		searchCompleter.queryFragment = queryFragment
	}
	
	// MARK: - Helpers
	
	func selectLocation(_ localSearch: MKLocalSearchCompletion) {
		locationSearch(forLocationSearchCompletion: localSearch) { response, error in
			if let error = error {
				print("DEBUG: FAILED location search failed with error: \(error.localizedDescription)")
				return
			}
			guard let item = response?.mapItems.first else { return }
			let coordinate = item.placemark.coordinate
			self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
			print("DEBUG: SUCCESS searched for location coordinate: \(coordinate)")
		}
	}
	
	func locationSearch(forLocationSearchCompletion localSearch: MKLocalSearchCompletion,
						completion: @escaping MKLocalSearch.CompletionHandler) {
		let searchRequest = MKLocalSearch.Request()
		searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
		let search = MKLocalSearch(request: searchRequest)
		search.start(completionHandler: completion)
	}
	
	func computeRidePrice(forType type: RideType) -> Double {
		guard let selectedUberLocation = selectedUberLocation?.coordinate ,
			  let userLocationCoordinate = self.userLocationCoordinate else {
			return 0.0
		}
		let startLocation = CLLocation(latitude: userLocationCoordinate.latitude, longitude: userLocationCoordinate.longitude)
		let finalLocation = CLLocation(latitude: selectedUberLocation.latitude, longitude: selectedUberLocation.longitude)
		let tripDistanceInMeters = startLocation.distance(from: finalLocation)
		return type.computePrice(for: tripDistanceInMeters)
	}
	
	func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (MKRoute) -> Void) {
		let userPlacemark = MKPlacemark(coordinate: userLocation)
		let destinationPlacemark = MKPlacemark(coordinate: destination)
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: userPlacemark)
		request.destination = MKMapItem(placemark: destinationPlacemark)
		let directions = MKDirections(request: request)
		directions.calculate { response, error in
			if let error = error {
				print("DEBUG: Failed to get directions with error: \(error.localizedDescription)")
				return
			}
			guard let route = response?.routes.first else { return }
			self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
			completion(route)
		}
	}
	
	func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
		let formatter = DateFormatter()
		formatter.dateFormat = "hh:mm a"
		pickupTime = formatter.string(from: Date())
		dropoffTime = formatter.string(from: Date() + expectedTravelTime)
	}
	
}


extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
	
	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		self.results = completer.results
	}
	
}
