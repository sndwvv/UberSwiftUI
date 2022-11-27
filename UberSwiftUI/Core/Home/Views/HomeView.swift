//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by Songyee Park on 2022/10/05.
//

import SwiftUI

struct HomeView: View {
	
	@State private var mapState = MapViewState.noInput
	@EnvironmentObject var viewModel: LocationSearchViewModel
	
    var body: some View {
		ZStack(alignment: .bottom) {
			ZStack(alignment: .top) {
				UberMapViewRepresentable(mapState: $mapState)
					.ignoresSafeArea()
				
				if mapState == .searchingForLocation {
					LocationSearchView(mapState: $mapState)
				} else if mapState == .noInput {
					LocationSearchActivationView()
						.padding(.top, 72)
						.onTapGesture {
							withAnimation(.spring()) {
								mapState = .searchingForLocation
							}
						}
				}
				
				MapViewActionButton(mapState: $mapState)
					.padding(.leading)
					.padding(.top, 4)
			}
			
			if mapState == .locationSelected || mapState == .polylineAdded {
				RideRequestView()
					.transition(.move(edge: .bottom))
			}
		}
		.edgesIgnoringSafeArea(.bottom)
		.onReceive(LocationManager.shared.$userLocationCoordinate) { location in
			if let location = location {
				viewModel.userLocationCoordinate = location
			}
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
