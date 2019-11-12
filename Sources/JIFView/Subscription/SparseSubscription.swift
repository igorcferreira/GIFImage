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
    private var completed: Bool = false
    
    init(subscriber: SubscriberType, upstream: Stream, frameRate: TimeInterval, loop: Bool, scheduler: S) {
        self.scheduler = scheduler
        self.subscriber = subscriber
        self.upstream = upstream
        self.frameRate = Int(frameRate * 1000.0)
        self.loop = loop
    }
    
    func request(_ demand: Subscribers.Demand) {
        completed = false
        clearState()
        cancellable = upstream.sink(receiveCompletion: { [weak self] _ in
            self?.completed = true
        }, receiveValue: { [weak self] (input) in
            self?.append(input: input)
        })
    }
    
    private func append(input: Stream.Output) {
        //This strategy of previously empty
        //is in place to avoid doing .count on all inputs
        let previouslyEmpty = elements.isEmpty
        elements.append(input)
        if previouslyEmpty {
            self.startAnimation()
        }
    }
    
    private func startAnimation() {
        let type = DispatchQueue.SchedulerTimeType(DispatchTime.now())
        let tolerance = DispatchQueue.SchedulerTimeType.Stride(DispatchTimeInterval.milliseconds(0))
        let interval = DispatchQueue.SchedulerTimeType.Stride(DispatchTimeInterval.milliseconds(frameRate))
        dispatcher = scheduler.schedule(after: type, interval: interval, tolerance: tolerance) { [weak self] in
            self?.trigger()
        }
    }
    
    private func finishOperation() {
        if loop {
            frameIndex = 0
        } else {
            closeAnimation()
            subscriber?.receive(completion: .finished)
        }
    }
    
    private func trigger() {
        guard frameIndex < elements.count else {
            if completed { finishOperation() }
            return
        }
        
        let frame = elements[frameIndex]
        _ = subscriber?.receive(frame)
        frameIndex += 1
    }
    
    private func closeAnimation() {
        dispatcher?.cancel()
        dispatcher = nil
    }
    
    private func closeStream() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    private func clearState() {
        closeAnimation()
        closeStream()
    }
    
    func cancel() {
        clearState()
        subscriber = nil
    }
}
#endif
