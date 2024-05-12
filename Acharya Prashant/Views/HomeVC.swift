//
//  HomeVC.swift
//  Acharya Prashant
//
//  Created by Sonkar, Swapnil on 11/05/24.
//

import Combine
import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: HomeVM!
    var input = PassthroughSubject<HomeVM.Input, Never>()
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        registerForTraitChanges([UITraitVerticalSizeClass.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
        
        viewModel = HomeVM(networkManager: NetworkManager())
        bind()
        input.send(.loadCoverageData)
    }
}

// Bind
extension HomeVC {

    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .fetchCoverageFailed(let error):
                    print(error)
                    self?.fetchFailAlert(message: error.localizedDescription)
                    
                case .fetchCoverageSuceeded:
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel.$coverages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension HomeVC {
    
    func fetchFailAlert(message: String) {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [unowned self] action in
            self.input.send(.loadCoverageData)
        }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.coverages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVC.reuseIdentifier, for: indexPath) as! ImageCVC
        
        let coverage = viewModel.coverages[indexPath.row]
        let representedIdentifier = "\(coverage.thumbnail!.domain)/\(coverage.thumbnail!.basePath)/0/\(coverage.thumbnail!.key)"
        cell.representedIdentifier = representedIdentifier
        
        Task { 
            cell.imageView.image = nil
            let image = await coverage.thumbnail?.image
            if cell.representedIdentifier == representedIdentifier {
                cell.imageView.image = image
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = calculateItemWidth(collectionView: collectionView, itemInOneRow: 3, distanceBetweenItem: 10)
        return CGSize(width: width, height: width)
    }
    
    func calculateItemWidth(collectionView: UICollectionView, itemInOneRow: UInt8, distanceBetweenItem: CGFloat) -> CGFloat {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let screenWidth = collectionView.bounds.width
        let itemInOneRow = CGFloat(itemInOneRow)
        let totalMargin = layout.sectionInset.left + layout.sectionInset.right + distanceBetweenItem * (itemInOneRow - 1)

        guard totalMargin < screenWidth else {
            return screenWidth / itemInOneRow
        }
                
        let sumOfItemSize = screenWidth - totalMargin
        
        return (sumOfItemSize / itemInOneRow).rounded(.down)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}
