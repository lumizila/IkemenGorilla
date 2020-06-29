//
//  ServiceProvider.swift
//  Gorilla
//
//  Created by admin on 2020/06/29.
//  Copyright © 2020 admin. All rights reserved.
//

protocol ServiceProviderType: AnyObject {
    var contestService: ContestServiceType { get set }
    var animalService: AnimalServiceType { get set }
    var zooService: ZooServiceType { get set }
}

final class ServiceProvider: ServiceProviderType {
    
    private lazy var contestRepository = ContestRepository(networkProvider: NetworkProvider<ContestTarget>())
    private lazy var animalRepository = AnimalRepository(networkProvider: NetworkProvider<AnimalTarget>())
    private lazy var zooRepository = ZooRepository(networkProvider: NetworkProvider<ZooTarget>())
    
    lazy var contestService: ContestServiceType = ContestService(provider: self, contestRepository: contestRepository)
    lazy var animalService: AnimalServiceType = AnimalService(provider: self, animalRepository: animalRepository)
    lazy var zooService: ZooServiceType = ZooService(provider: self, zooRepository: zooRepository)
}
