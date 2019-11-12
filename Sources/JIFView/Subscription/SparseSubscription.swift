//
//  SparseSubscription.swift
//  JIFTest
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Igor Ferreira. All rights reserved.
//

#if canImport(Combine)
import Combine
import Foundation

@available(iOS 13, OSX 10.15, *)
final class SparseSubscription<SubscriberType: Subscriber, Stream: Publisher, S: Scheduler>: Subscription
where SubscriberType.Input == Stream.Output, SubscriberType.Failure == Stream.Failure, S.SchedulerTimeType == DispatchQueue.SchedulerTimeType {
    
    private var subscriber: SubscriberType?
    private var elements: [Stream.Output] = []
    private var cancellable: Cancellable? = nil
    private var dispatcher: Cancellable? = nil
    private let upstream: Stream
    private let frameRate: Int
    private let loop: Bool
    private let scheduler: S
    private var frameIndex: Int = 0
    
    init(subscriber: SubscriberType, upstream: Stream, frameRate: TimeInterval, loop: Bool, scheduler: S) {
        self.scheduler = scheduler
        self.subscriber = subscriber
        self.upstream = upstream
        self.frameRate = Int(frameRate * 1000.0)
        self.loop = loop
    }
    
    func request(_ demand: Subscribers.Demand) {
        cancellable = upstream.sink(receiveCompletion: { _ in },
                                    receiveValue: { [weak self] (input) in
                                        self?.append(input: input)
        })
    }
    
    private func append(input: Stream.Output) {
        elements.append(input)
        if elements.count == 1 {
            let type = DispatchQueue.SchedulerTimeType(DispatchTime.now())
            let tolerance = DispatchQueue.SchedulerTimeType.Stride(DispatchTimeInterval.milliseconds(0))
            let interval = DispatchQueue.SchedulerTimeType.Stride(DispatchTimeInterval.milliseconds(frameRate))
            dispatcher = scheduler.schedule(after: type, interval: interval, tolerance: tolerance) { [weak self] in
                self?.trigger()
            }
        }
    }
    
    private func trigger() {
        guard frameIndex < elements.count else {
            if loop { frameIndex = 0 }
            return
        }
        
        let frame = elements[frameIndex]
        _ = subscriber?.receive(frame)
        frameIndex += 1
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
        subscriber = nil
    }
}
#endif
