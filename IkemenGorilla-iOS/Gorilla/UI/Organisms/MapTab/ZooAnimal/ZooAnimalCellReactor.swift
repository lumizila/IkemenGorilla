//
//  ZooAnimalCellReactor.swift
//  Gorilla
//
//  Created by admin on 2020/06/19.
//  Copyright © 2020 admin. All rights reserved.
//

import ReactorKit
import RxSwift

final class ZooAnimalCellReactor: Reactor {
    enum Action {}
    enum Mutation {}
    
    struct State {
        var animal: Animal
        
        init(animal: Animal) {
            self.animal = animal
        }
    }
    
    let initialState: State
    
    init(animal: Animal) {
        initialState = State(animal: animal)
    }
}
