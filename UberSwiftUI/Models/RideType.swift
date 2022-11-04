//
//  RideType.swift
//  UberSwiftUI
//
//  Created by Songyee Park on 2022/11/05.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable {
	case uberX
	case black
	case uberXL
	
	var id: Int { return rawValue }
	
	var description: String {
		switch self {
		case .uberX: return "UberX"
		case .black: return "UserBlack"
		case .uberXL: return "UberXL"
		}
	}
	
	var imageName: String {
		switch self {
		case .uberX: return "uber-x"
		case .black: return "uber-black"
		case .uberXL: return "uber-x"
		}
	}
}
