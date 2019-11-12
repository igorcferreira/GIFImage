//
//  File.swift
//  
//
//  Created by Igor Ferreira on 11/11/2019.
//

#if canImport(Combine) && canImport(UIKit)
import Combine
import UIKit

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
