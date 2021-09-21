//
//  RecipeDetailVC.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//

import UIKit
import RxSwift
import RxCocoa


class RecipeDetailVC: UIViewController {
    private var label: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private var favoriteBtn: UIButton = {
        // need better resizing instead of the extension
        let size = CGSize(width: 60, height: 50)
        let imgTrue = ImageSet.favoritesTRUE.resizedImage(size: size)!.withTintColor(Colors.pink)
        let imgFalse = ImageSet.favoritesFALSE.resizedImage(size: size)!.withTintColor(.white)
        
        let btn = UIButton()
        btn.setImage(imgFalse, for: .normal)
        btn.setImage(imgTrue, for: .selected)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = Colors.pink
        return btn
    }()
    var imageUrl: String {
        return viewModel.value.imageUrl
    }
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let bag = DisposeBag()
    var viewModel = BehaviorRelay<RecipeDetailViewModel>(value: RecipeDetailViewModel(recipe: Stubs.recipe))
    var viewModelObservable: Observable<RecipeDetailViewModel> {
        return viewModel.asObservable()
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setImageViewThumbnail(self.imageUrl)
    }
}


// MARK - PRIVATE: RecipeDetailVC
private extension RecipeDetailVC {
    func setImageViewThumbnail(_ url: String) -> Void {
        ImageLoader.shared().loadImage(url: url, then: {
            [weak self] data in
            guard self != nil else { return }
            
            if let img = UIImage(data: data) {
                self!.imageView.image = img
            } else {
                self!.imageView.image = ImageSet.placeholderImage
            }
        })
    }
    func updateBtnImage(_ btn: UIButton, model: RecipeDetailViewModel) -> Void {
        if (model.isFavorite.value) {
            btn.isSelected = true
        } else {
            btn.isSelected = false
        }
    }
    
    func configureUI() -> Void {
        configureNavigation(isHidden: false, textColor: Colors.gray)
        navigationItem.backButtonDisplayMode = .minimal
        title = "Detail"
        view.backgroundColor = Colors.gold
        view.addSubviews(imageView, label, favoriteBtn)
        
        // auto-layout: imageView
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        // auto-layout: label
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.2),
            label.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.6),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.height * 0.15)
        ])
        
        // auto-layout: favoriteBtn
        NSLayoutConstraint.activate([
            favoriteBtn.topAnchor.constraint(equalTo: label.bottomAnchor),
            favoriteBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func bindData() -> Void {
        // subscribe to local model updates
        viewModelObservable.subscribe(onNext: { viewModel in
            self.label.text = viewModel.title
            self.updateBtnImage(self.favoriteBtn, model: viewModel)
            viewModel.isFavoriteObservable.subscribe({ event in
                self.updateBtnImage(self.favoriteBtn, model: viewModel)
            }).disposed(by: self.bag)
        }).disposed(by: bag)
        
        // bind to the favoriteBtn interaction events and emit to local model
        favoriteBtn.rx.tap.bind {
            let isFavoriteSubject = self.viewModel.value.isFavorite
            isFavoriteSubject.accept(!isFavoriteSubject.value)
        }.disposed(by: bag)
    }
    
    func configureNavigation(isHidden: Bool, textColor: UIColor = Colors.gray) -> Void {
        navigationController?.navigationBar.isHidden = isHidden
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:textColor]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = textColor
    }
}
