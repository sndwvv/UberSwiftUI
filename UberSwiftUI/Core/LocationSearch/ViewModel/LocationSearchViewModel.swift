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
	@Published var selectedLocation: String?
	
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
	
	func selectLocation(_ location: String) {
		self.selectedLocation = location
	}
	
}


extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
	
	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		self.results = completer.results
	}
	
}
