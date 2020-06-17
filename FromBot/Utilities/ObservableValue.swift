//
//  ObservableValue.swift
//  FromBot
//
//  Created by Marwan Aziz on 07/06/2020.
//  Copyright © 2020 Marwan Aziz. All rights reserved.
//

import Foundation

class ObservableValue<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value:T) {
        self.value = value
        self.listener?(value)
    }

    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
