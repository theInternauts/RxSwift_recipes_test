//
//  StartScreenVC.swift
//  FavoriteRecipes
//
//  Created by Christopher Wallace on 9/20/21.
//

import UIKit


class StartScreenVC: UIViewController {
    var mainAppView: UIViewController?
    
    private let button: UIButton = {
       let btn = UIButton()
        btn.setTitle(ApplicationText.start.rawValue, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(navigateToNewView), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureNavigation(isHidden: true, textColor: Colors.gray)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    // MARK: - Navigation
    @objc func navigateToNewView(_ sender: UIButton) -> Void {
        guard let newView = mainAppView else {
            return
        }
        navigationController?.pushViewController(newView, animated: true)
    }
}


private extension StartScreenVC {
    func configureUI() -> Void {
        configureNavigation(isHidden: true, textColor: Colors.gray)
        navigationItem.backButtonDisplayMode = .minimal
        view.backgroundColor = .systemPurple
        view.addSubview(button)
        title = ApplicationText.start.rawValue
    }
    
    func configureNavigation(isHidden: Bool, textColor: UIColor = Colors.gray) -> Void {
        navigationController?.navigationBar.isHidden = isHidden
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:textColor]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = textColor
    }
}

