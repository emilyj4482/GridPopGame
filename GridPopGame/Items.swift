//
//  Items.swift
//  GridPopGame
//
//  Created by EMILY on 31/05/2025.
//

import Foundation

enum Items: CaseIterable {
    case cheese
    case mackerel
    case gray
    case calico
    case vanila
    
    var imageName: String {
        switch self {
        case .cheese:
            return "cheese"
        case .mackerel:
            return "mackerel"
        case .gray:
            return "gray"
        case .calico:
            return "calico"
        case .vanila:
            return "vanila"
        }
    }
}
