//
//  SparsePublisher.swift
//  JIFTest
//
//  Created by Igor Ferreira on 11/11/2019.
//  Copyright © 2019 Future Workshops. All rights reserved.
//

#if canImport(Combine)
import Combine
import Foundation

@available(iOS 13, OSX 10.15, *)
extension Publisher {
    func sparsed<S: Scheduler>(frameRate: TimeInterval, loop: Bool, scheduler: S) -> Publishers.Sparse<Self, S>
        where S.SchedulerTimeType == DispatchQueue.SchedulerTimeType {
        return Publishers.Sparse(upstream: self,
                                 frameRate: frameRate,
                                 loop: loop,
                                 scheduler: scheduler)
    }
}

@available(iOS 13, OSX 10.15, *)
extension Publishers {
    final class Sparse<Upstream: Publisher, S: Scheduler>: Publisher
    where S.SchedulerTimeType == DispatchQueue.SchedulerTimeType {
        typealias Output = Upstream.Output
        typealias Failure = Upstream.Failure
        
        let upstream: Upstream
        let frameRate: TimeInterval
        let loop: Bool
        let scheduler: S
        var subscribed: AnyPublisher<Output, Failure>?
        
        init(upstream: Upstream, frameRate: TimeInterval, loop: Bool, scheduler: S) {
            self.upstream = upstream
            self.frameRate = frameRate
            self.loop = loop
            self.scheduler = scheduler
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input {
            let subscription = SparseSubscription(subscriber: subscriber,
                                                  upstream: upstream,
                                                  frameRate: frameRate,
                                                  loop: loop,
                                                  scheduler: scheduler)
            subscriber.receive(subscription: subscription)
        }
    }
}
#endif
