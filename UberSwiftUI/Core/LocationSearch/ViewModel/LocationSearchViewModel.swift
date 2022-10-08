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
	@Published var selectedLocationCoordinate: CLLocationCoordinate2D? 
	
	private var searchCompleter = MKLocalSearchCompleter()
	
	var queryFragment: String = "" {
		didSet {
			searchCompleter.queryFragment = queryFragment
		}
	}
	
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
			self.selectedLocationCoordinate = coordinate
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
	
}


extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
	
	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		self.results = completer.results
	}
	
}
