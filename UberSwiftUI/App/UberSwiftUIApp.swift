//
//  UberSwiftUIApp.swift
//  UberSwiftUI
//
//  Created by Songyee Park on 2022/10/05.
//

import SwiftUI

@main
struct UberSwiftUIApp: App {
	
	@StateObject var locationViewModel = LocationSearchViewModel()
	
    var body: some Scene {
        WindowGroup {
			HomeView()
				.environmentObject(locationViewModel)
        }
    }
}
