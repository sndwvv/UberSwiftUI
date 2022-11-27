//
//  Color.swift
//  UberSwiftUI
//
//  Created by Songyee Park on 2022/11/27.
//

import SwiftUI

extension Color {
	static let theme = ColorTheme()
}

struct ColorTheme {
	let backgroundColor = Color("BackgroundColor")
	let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
	let primaryTextColor = Color("PrimaryTextColor")
}
