//
//  ProductViewController.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ProductViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addProductBtn: UIButton!
    
    let productViewModel = ProductViewModel()
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<ProductSection>!
    let bag = DisposeBag()
    let cellId = "ProductTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        setupDataSource()
        setupObservers()
    }
    
    var once = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !once {
            once = true
            productViewModel.getProductList()
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.refreshControl = UIRefreshControl()
        tableView.rx.setDelegate(self).disposed(by: bag)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.productViewModel.getProductList()
            })
            .disposed(by: bag)
    }

    private func setupDataSource() {
        let animationConfiguration = AnimationConfiguration(insertAnimation: .none,
                                                            reloadAnimation: .none,
                                                            deleteAnimation: .left)
        dataSource = RxTableViewSectionedAnimatedDataSource<ProductSection>(
            animationConfiguration: animationConfiguration, configureCell: configureCell
        )
        
        productViewModel.sections.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        currentLoggedInToken.distinctUntilChanged().subscribe(onNext: { [weak self] loggedInToken in
            DispatchQueue.main.async {
                if loggedInToken.isEmpty {
                    // User is not logged in
                    self?.addProductBtn.setBtnEnabled(false)
                } else {
                    // User is logged in
                    self?.addProductBtn.setBtnEnabled(true)
                }
                self?.tableView.reloadData()
            }
            
        }).disposed(by: bag)
    }
    
    private func setupObservers() {
        _ = searchTextField.rx.text.map{$0 ?? ""}.bind(to: productViewModel.searchText)
        productViewModel.searchText.throttle(.microseconds(300), scheduler: MainScheduler.instance).distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.productViewModel.applyFiltering()
        }).disposed(by: bag)
        
        productViewModel.isLoadingValue.distinctUntilChanged().subscribe(onNext: { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.showLoadingValue(isLoading)
                if !isLoading, let isRefreshing = self?.tableView.refreshControl?.isRefreshing, isRefreshing {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
        }).disposed(by: bag)
    }
    
    private var configureCell: RxTableViewSectionedAnimatedDataSource<ProductSection>.ConfigureCell {
        return { [unowned self] _, tableView, indexPath, product in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId) as! ProductTableViewCell
            cell.setupWithProduct(product, isLoggedIn: !currentLoggedInToken.value.isEmpty)
            cell.selectionStyle = .none
            cell.viewController = self
            return cell
        }
    }

    // Actions from row
    func editRowAtCell(_ cell: ProductTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let addProductViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController {
                addProductViewController.productViewModel = productViewModel
                addProductViewController.existingProduct = productViewModel.displayedProductList[indexPath.row]
                present(addProductViewController, animated: true, completion: nil)
            }
        }
    }
    
    func deleteRowAtCell(_ cell: ProductTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            productViewModel.deleteRowAtIndex(indexPath.row)
        }
    }
    
    // Actions
    @IBAction func tapAddProductBtn(_ sender: Any) {
        if let addProductViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController {
            addProductViewController.productViewModel = productViewModel
            present(addProductViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapRegisterBtn(_ sender: Any) {
        goToUserInputScreen(forRegister: true)
    }
    
    @IBAction func tapLoginBtn(_ sender: Any) {
        goToUserInputScreen(forRegister: false)
    }
    
    func goToUserInputScreen(forRegister: Bool) {
        if let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            loginViewController.forRegister = forRegister
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}

extension ProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let productHeaderView = UINib(nibName: "ProductHeaderView", bundle: nil).instantiate(withOwner: self, options: nil).first as! ProductHeaderView
        productHeaderView.frame = CGRect(x: 0, y: 0, width: Constants.ScreenSize.ScreenWidth - 40, height: 40)
        return productHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
