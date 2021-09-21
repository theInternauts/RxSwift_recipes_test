//
//  RecipeListingVC.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//

import UIKit
import RxSwift
import RxCocoa


class RecipeListingVC: UIViewController {
    let tabBarItemLabelText: String
    let tabBarItemIconActive: UIImage
    let tabBarItemIconInactive: UIImage
    
    let viewModel: RecipeListViewModel!
    let dataList = BehaviorRelay<[RecipeDetailViewModel]>(value: [])
    let filteredDataList = BehaviorRelay<[RecipeDetailViewModel]>(value: [])
    var recipeDetailVC: RecipeDetailVC?
    private let bag = DisposeBag()
    
    var collectionView: UICollectionView?
    
    
    // MARK: - Initialization
    init(tabBarItemLabelText: String,
         tabBarItemIconActive: UIImage,
         tabBarItemIconInactive: UIImage,
         viewModel: RecipeListViewModel = RecipeListViewModel()) {
        
        self.tabBarItemLabelText = tabBarItemLabelText
        self.tabBarItemIconActive = tabBarItemIconActive
        self.tabBarItemIconInactive = tabBarItemIconInactive
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchRecipeViewModels()
        recipeDetailVC = RecipeDetailVC()
        configureCollectionView()
        configureUI()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*
                THIS IS BAD.
         
                I know...
         */
        
        viewModel.fetchRecipeViewModels()
        
        /*
         PLEASE READ: I am adding this to ensure
         the User will SEE the expected UI when favoriting
         a recipe from any other controller.  I need to learn more about
         RxSwift to ensure that the model is observed across all controllers.
         
         I am still have trouble with that. This is a hack
         to deliver a WORKING app.  I needs much improvement; but deadlines
         for buisness are real and SOMETIMES you have to ship a working prodcut
         that is not PERFECT code.
         
         RxSwift -- I have many questions about the PROPER way to do this.
         - Should I have put a single model on the UITabController as the
         single source of truth for all data displays?
         - Or maybe sync to CoreData and read from there on every update?
         Was it a bad choice to serialize the entire recipe model and store
         that in UserDefaults?
         
         
         Let's talk about it.
        */
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureNavigation(isHidden: false, textColor: Colors.gray)
        
        if let cv = collectionView {
            cv.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cv.leftAnchor.constraint(equalTo: view.leftAnchor),
                cv.rightAnchor.constraint(equalTo: view.rightAnchor),
                cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                cv.topAnchor.constraint(equalTo: view.topAnchor)
            ])
        }
    }
}


// MARK: PRIVATE - RecipeListingVC
private extension RecipeListingVC {
    func configureUI() -> Void {
        configureNavigation(isHidden: false, textColor: Colors.gray)
        view.backgroundColor = .systemBackground
        navigationItem.backButtonDisplayMode = .minimal
        title = ApplicationText.recipes.rawValue
        navigationItem.title = ApplicationText.recipes.rawValue
    }
    
    func configureCollectionView() -> Void {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateCollectionViewLayout())
        collectionView?.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.reuseIdentifier)
//        collectionView?.register(TestRxRecipeCollectionViewCell.self, forCellWithReuseIdentifier: TestRxRecipeCollectionViewCell.reuseIdentifier)
        collectionView?.backgroundColor = .systemBackground
        view.addSubview(collectionView!)
    }
    
    func generateCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 24
        
        let calcVal = view.frame.size.width - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right
        let cellWidthHeightConstant: CGFloat = calcVal / 2
        layout.itemSize = CGSize(width: cellWidthHeightConstant, height: cellWidthHeightConstant)
        
        return layout
    }
    
    func bindData() -> Void {
        guard let collectionView = collectionView else {
            fatalError("self.viewModel: RecipeListViewModel cannot be bound to becasue self.collectionView: UICollectionView? is not present")
        }
        
        // populate local view display
        viewModel.recipeDetailObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (value) in
            guard let self = self else { return }
            
            self.filteredDataList.accept(value)
            self.dataList.accept(value)
        },onError: { error in
            self.errorAlert()
        }).disposed(by: bag)
        

        // bind to reusable cells
        filteredDataList
            .bind(to: collectionView.rx
                    .items(cellIdentifier: RecipeCollectionViewCell.reuseIdentifier,
                           cellType: RecipeCollectionViewCell.self))
            { row, model, cell in
                cell.configure(model)
                cell.viewModel.value.isFavoriteObservable
                    .observe(on: MainScheduler.instance)
                    .distinctUntilChanged()
                    .subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        
                        self.viewModel.updateFavoritesPersistenceStatus(model)
                    }).disposed(by: cell.bag)
            }.disposed(by: bag)
        
        // subcribe to selected item in local display
        collectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (indexPath) in
                guard let self = self else { return }
                
                let model = self.filteredDataList.value[indexPath.row]
                self.collectionView?.deselectItem(at: indexPath, animated: true)
                self.recipeDetailVC?.viewModel.accept(model)
                self.recipeDetailVC?.viewModel.value.isFavoriteObservable
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        
                        self.viewModel.updateFavoritesPersistenceStatus(model)
                    }).disposed(by: self.bag)
                
                self.navigationController?.pushViewController(self.recipeDetailVC ?? RecipeDetailVC(), animated: true)
            }).disposed(by: bag)
    }
    
    func configureNavigation(isHidden: Bool, textColor: UIColor = Colors.gray) -> Void {
        navigationController?.navigationBar.isHidden = isHidden
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:textColor]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = textColor
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Error", message: "Check your Internet connection and Try Again!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


// MARK: UITabBarEnabled
extension RecipeListingVC: UITabBarEnabled {}
