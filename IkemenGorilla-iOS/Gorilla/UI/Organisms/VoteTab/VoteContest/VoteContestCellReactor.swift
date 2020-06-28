//
//  VoteContestCellReactor.swift
//  Gorilla
//
//  Created by admin on 2020/06/27.
//  Copyright © 2020 admin. All rights reserved.
//

import ReactorKit
import RxSwift

final class VoteContestCellReactor: Reactor {
    enum Action {}
    enum Mutation {}
    
    struct State {
        let contest: Contest
        
        init(contest: Contest) {
            self.contest = contest
        }
    }
    
    let initialState: State
    
    init(contest: Contest) {
        initialState = State(contest: contest)
    }
}

extension VoteContestCellReactor: Equatable {
    static func == (lhs: VoteContestCellReactor, rhs: VoteContestCellReactor) -> Bool {
        return lhs.currentState.contest.id == rhs.currentState.contest.id
    }
}
