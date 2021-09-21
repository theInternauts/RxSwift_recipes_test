//
//  RecipeCollectionViewCell.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//

import UIKit


class RecipeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: self)
    
    var imageUrl: String {
        return viewModel?.imageUrl ?? ""
    }
    private var favoriteBtn: UIButton = {
        // need better resizing instead of the extension
        let size = CGSize(width: 30, height: 25)
        let imgTrue = ImageSet.favoritesTRUE.resizedImage(size: size)!.withTintColor(Colors.pink)
        let imgFalse = ImageSet.favoritesFALSE.resizedImage(size: size)!.withTintColor(.white)
        
        let btn = UIButton()
        btn.setImage(imgFalse, for: .normal)
        btn.setImage(imgTrue, for: .selected)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = Colors.pink
        return btn
    }()
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.layer.borderColor = .none
        view.layer.borderWidth = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var label: UILabel = {
        let label = UILabel()
        label.text = "something"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = Colors.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var viewModel: RecipeDetailViewModel?
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.borderColor = Colors.gray.cgColor
        contentView.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.bag = DisposeBag()
        isHidden = false
        isSelected = false
        isHighlighted = false
        imageView.image = nil
    }
    
    
    // MARK: - Public
    func configure(_ viewModel: RecipeDetailViewModel) -> Void {
        self.label.text = viewModel.title
        self.label.addCharacterTracking(2)
        self.viewModel = viewModel
        
        self.setImageViewThumbnail(viewModel.imageUrl)
        self.updateBtnImage(favoriteBtn, model: viewModel)
    }
}


// MARK: - UI Setup
private extension RecipeCollectionViewCell {
    func updateBtnImage(_ btn: UIButton,
                        model: RecipeDetailViewModel) -> Void {
        
        if (model.isFavorite.value) {
            print("TRUE ==> FILL: \(String(describing: model.isFavorite.value))")
            btn.isSelected = true
        } else {
            print("FALSE ==> EMPTY: \(String(describing: model.isFavorite.value))")
            btn.isSelected = false
        }
    }
    
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
    
    func configureUI() {
        self.contentView.addSubviews(imageView, label, favoriteBtn)
        
        // auto-layout: imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        // auto-layout: label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -4)
        ])
        
        // auto-layout: favoriteBtn
        NSLayoutConstraint.activate([
            favoriteBtn.topAnchor.constraint(equalTo: imageView.topAnchor, constant: contentView.bounds.width * 0.05),
            favoriteBtn.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: contentView.bounds.width * -0.05)
        ])
        
    }
}

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

class TestRxRecipeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: self)
    
    private var viewModel: RecipeDetailViewModel?
    
    var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "wordssss"
        return l
    }()
    
    var imageView: UIImageView! = {
        let l = UIImageView()
        l.contentMode = .scaleAspectFill
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    func configure(_ viewModel: RecipeDetailViewModel) {
        self.label.text = viewModel.title
        self.viewModel = viewModel
        
        self.updateBgdImage(imageView, model: viewModel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubviews(imageView,label)
        
        // auto-layout: label
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 200),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        
        // auto-layout: imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func updateBgdImage(_ imageView: UIImageView,
                        model: RecipeDetailViewModel) -> Void {
        if (model.isFavorite.value) {
            imageView.image = UIImage(systemName: "bookmark.fill")?
                .withTintColor(Colors.pink, renderingMode: .alwaysOriginal)
        } else {
            imageView.image = UIImage(systemName: "bookmark.slash")?
                .withTintColor(Colors.gold, renderingMode: .alwaysOriginal)
        }
    }
}
