//
//  VotedContestCellReactor.swift
//  Gorilla
//
//  Created by admin on 2020/06/11.
//  Copyright © 2020 admin. All rights reserved.
//

import ReactorKit
import RxSwift

final class VotedContestCellReactor: Reactor {
    enum Action {}
    enum Mutation {}
    
    struct State {
        let contest: Contest
        
        init(contest: Contest) {
            self.contest = contest
        }
    }
    
    let initialState: VotedContestCellReactor.State
    
    init(contest: Contest) {
        initialState = State(contest: contest)
    }
}

extension VotedContestCellReactor: Equatable {
    static func == (lhs: VotedContestCellReactor, rhs: VotedContestCellReactor) -> Bool {
        return lhs.currentState.contest.id == rhs.currentState.contest.id
    }
}
