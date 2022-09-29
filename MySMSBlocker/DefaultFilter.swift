//
//  DefaultFilter.swift
//  MySMSBlocker
//
//  Created by Scott Gruby on 10/1/22.
//

import Foundation

struct DefaultFilter: Codable {
    var match: String
    var sender: Bool
    var allow: Bool
}
