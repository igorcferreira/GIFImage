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
    
    private let TimeIntervalMillisecondsScale = 1_000.0
    
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
    private let subscriptionQueue = DispatchQueue(label: "Combine.SparseSubscription.\(UUID().uuidString)", qos: .userInteractive)
    
    init(subscriber: SubscriberType, upstream: Stream, frameRate: TimeInterval, loop: Bool, scheduler: S) {
        self.scheduler = scheduler
        self.subscriber = subscriber
        self.upstream = upstream
        self.frameRate = Int(frameRate * TimeIntervalMillisecondsScale)
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
        subscriptionQueue.sync { [weak self] in
            guard let self = self else { return }
            //This strategy of previously empty
            //is in place to avoid doing .count on all inputs
            let previouslyEmpty = self.elements.isEmpty
            self.elements.append(input)
            if previouslyEmpty {
                self.startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        let type = DispatchQueue.SchedulerTimeType(DispatchTime.now())
        let tolerance = DispatchQueue.SchedulerTimeType.Stride(DispatchTimeInterval.milliseconds(0))
        let interval = DispatchQueue.SchedulerTimeType.Stride(DispatchTimeInterval.milliseconds(frameRate))
        dispatcher = scheduler.schedule(after: type, interval: interval, tolerance: tolerance) { [weak self] in
            self?.subscriptionQueue.sync { [weak self] in
                self?.trigger()
            }
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
        let index = frameIndex
        
        guard index < elements.count else {
            if completed { finishOperation() }
            return
        }
        frameIndex = index + 1
        let frame = elements[index]
        _ = subscriber?.receive(frame)
    }
    
    private func closeAnimation() {
        dispatcher?.cancel()
        dispatcher = nil
    }
    
    private func closeStream() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    private func resetBuffer() {
        elements.removeAll()
        frameIndex = 0
    }
    
    private func clearState() {
        guard subscriber != nil, !elements.isEmpty else {
            return
        }
        
        closeAnimation()
        closeStream()
        resetBuffer()
    }
    
    func cancel() {
        clearState()
        subscriber = nil
    }
}
#endif
