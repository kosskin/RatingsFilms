// PushDelegate.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Protocol to push on new ViewController
protocol PushDelegate: AnyObject {
    func pushOnVC(movie: Movie)
}
