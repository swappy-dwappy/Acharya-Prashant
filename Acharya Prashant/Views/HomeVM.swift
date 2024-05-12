//
//  HomeVM.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 11/05/24.
//

import Combine
import Foundation
import UIKit

class HomeVM {
    
    private var output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManager
    
    @Published var coverages = [Coverage]()
    @Published var image: UIImage? = UIImage()
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

// State
extension HomeVM {
    
    enum Input {
        case loadCoverageData
    }
    
    enum Output {
        case fetchCoverageFailed(error: Error)
        case fetchCoverageSuceeded
    }
}

extension HomeVM {
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] value in
            switch value {
            case .loadCoverageData:
                self?.getAllCoverage()
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

// Network
extension HomeVM {
    private func getAllCoverage() {
        Task {
            switch await networkManager.getMediaCoverage(limit: 300) {
            case .success(let coverages):
                self.coverages = coverages
                output.send(.fetchCoverageSuceeded)
            case .failure(let error):
                output.send(.fetchCoverageFailed(error: error))
            }
        }
    }
}
