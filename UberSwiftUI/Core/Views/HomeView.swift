//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by Songyee Park on 2022/10/05.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        UberMapViewRepresentable()
			.ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
