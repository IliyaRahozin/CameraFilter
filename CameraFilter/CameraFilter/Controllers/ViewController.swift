//
//  ViewController.swift
//  CameraFilter
//
//  Created by Illia Rahozin on 15.11.2023.
//

import UIKit
import RxSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
                  fatalError("Segue destination is not found")
              }
        photosCVC.selectedPhoto.subscribe { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }.disposed(by: disposeBag )
    }
    
    @IBAction func applyFilterButtonPressed() {
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        // MARK: - Observable variant
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }
            ).disposed(by: disposeBag)
        
        // MARK: - Closure variant
        //        FilterService().applyFilter(to: sourceImage) { filteredImage in
        //            DispatchQueue.main.async {
        //                self.photoImageView.image = filteredImage
        //            }
        //        }
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.filterButton.isHidden = false
    }

}

