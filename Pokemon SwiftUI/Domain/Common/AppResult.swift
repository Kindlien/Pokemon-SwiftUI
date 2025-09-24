//
//  AppResult.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

enum AppResult<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
