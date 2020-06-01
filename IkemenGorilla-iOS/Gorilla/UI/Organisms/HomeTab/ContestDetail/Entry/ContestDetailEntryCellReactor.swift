//
//  ContestDetailEntryCellReactor.swift
//  Gorilla
//
//  Created by admin on 2020/06/01.
//  Copyright © 2020 admin. All rights reserved.
//

import ReactorKit
import RxSwift

final class ContestDetailEntryCellReactor: Reactor {
    enum Action {}
    enum Mutation {}
    
    struct State {
        let entry: Entry
        
        init(entry: Entry) {
            self.entry = entry
        }
    }
    
    let initialState: ContestDetailEntryCellReactor.State
    
    init(entry: Entry) {
        initialState = State(entry: entry)
    }
}

extension ContestDetailEntryCellReactor: Equatable {
    static func == (lhs: ContestDetailEntryCellReactor, rhs: ContestDetailEntryCellReactor) -> Bool {
        return lhs.currentState.entry.animalId == rhs.currentState.entry.animalId
    }
}
