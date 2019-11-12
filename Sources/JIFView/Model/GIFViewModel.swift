//
//  File.swift
//  
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

#if canImport(Combine)
import Combine

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

@available(iOS 13, OSX 10.15, *)
extension Publisher where Output == Data, Failure == Never {
    func mapToGIFStream<S: Scheduler>(frameRate: TimeInterval, loop: Bool, scheduleOn: S) -> AnyPublisher<UIImage?, Never>
        where S.SchedulerTimeType == DispatchQueue.SchedulerTimeType {
        return self.compactMap({ CGImageSourceCreateWithData($0 as CFData, nil) })
            .flatMap(CGImageSource.getImages(_:))
            .map(UIImage.init(cgImage:))
            .sparsed(frameRate: frameRate, loop: loop, scheduler: scheduleOn)
            .eraseToAnyPublisher()
    }
}

#endif
