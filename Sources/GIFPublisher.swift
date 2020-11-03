//
//  File.swift
//  
//
//  Created by Igor Ferreira on 03/11/2020.
//

import Foundation
import Combine

fileprivate class GIFSubscription<Target: Subscriber>: Subscription where Target.Input == GIFFrame {
    let combineIdentifier: CombineIdentifier = CombineIdentifier(UUID().uuidString as NSString)
    
    let currentFrame: Int = 0
    let delayQueue = DispatchQueue(label: "GIFSubscription", qos: .background)
    let frames: [GIFFrame]
    var target: Target?
    
    init(frames: [GIFFrame], target: Target) {
        self.frames = frames
        self.target = target
    }
    
    func request(_ demand: Subscribers.Demand) {
        guard demand > Subscribers.Demand.none else { return }
        trigger(frame: currentFrame)
    }
    
    func cancel() {
        target = nil
    }
    
    private func finish() {
        target?.receive(completion: .finished)
    }
    
    private func trigger(frame: Int) {
        guard let target = target else { return }
        guard frame < frames.count else { return finish() }
        let gifFrame = frames[frame]
        let _ = target.receive(gifFrame)
        delayQueue.asyncAfter(deadline: .now() + gifFrame.delay) { [weak self] in
            self?.trigger(frame: frame + 1)
        }
    }
}

struct GIFPublisher: Publisher {
    typealias Output = GIFFrame
    typealias Failure = Never
    
    let frames: [GIFFrame]
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = GIFSubscription(frames: frames, target: subscriber)
        subscriber.receive(subscription: subscription)
    }
}
