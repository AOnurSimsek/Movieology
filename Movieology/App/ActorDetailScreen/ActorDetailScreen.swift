//
//  ActorDetailScreen.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 12.08.2022.
//

import UIKit
import SnapKit
import SafariServices

final class ActorDetailScreenViewController: BaseViewController<ActorDetailViewModel> {
    
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var mainView: UIView = UIView()
    private lazy var backButton: UIButton = UIButton()
    private lazy var homeButton: UIButton = UIButton()
    private lazy var actorPosterImageView: UIImageView = UIImageView()
    private lazy var nameLabel: UILabel = UILabel()
    private lazy var birthdayLabel: UILabel = UILabel()
    private lazy var IMDBButton: UIButton = UIButton()
    private lazy var webSiteButton: UIButton = UIButton()
    private lazy var biographyLabel: UILabel = UILabel()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                         collectionViewLayout: UICollectionViewFlowLayout())
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setCollectionView()
        addTargets()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading()
        viewModel.getData()
    }
    
    private func bind() {
        viewModel.actorDetails.bind { [weak self] _ in
            guard let self = self
            else { return }
            self.viewModel.getImage(to: self.actorPosterImageView)
            self.nameLabel.text = self.viewModel.getNameText()
            self.birthdayLabel.attributedText = self.viewModel.getAttributedText(type: .birthday)
            self.biographyLabel.attributedText = self.viewModel.getAttributedText(type: .biography)
            self.webSiteButton.isHidden = !self.viewModel.getWebsiteStatus()
            
            self.removeLoading()
        }
        
        viewModel.actorCasts.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.error.bind { [weak self] error in
            if let _error = error {
                self?.showAlert(_error)
            }
        }
        
    }
    
    private func openWeb(type: DetailUrlTypes) {
        guard let url = viewModel.getURL(type: type)
        else { return }
        let viewController = SFSafariViewController(url: url)
        self.present(viewController, animated: true)
    }
    
    private func addTargets() {
        backButton.addTarget(self, action: #selector(backtoPreviousVC), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(backtoHomeVC), for: .touchUpInside)
        webSiteButton.addTarget(self, action: #selector(gotoWebsite), for: .touchUpInside)
        IMDBButton.addTarget(self, action: #selector(gotoImdb), for: .touchUpInside)
    }
    
    @objc func backtoPreviousVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backtoHomeVC() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func gotoWebsite() {
        openWeb(type: .website)
    }
    
    @objc func gotoImdb() {
        openWeb(type: .imdb)
    }
}

//MARK: - UI and Layout
extension ActorDetailScreenViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor(hexString: "071037")
        
        scrollView.bounces = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        
        backButton.backgroundColor = .clear
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.tintColor = .white
        
        homeButton.backgroundColor = .clear
        homeButton.setImage(UIImage(named: "homeIcon"), for: .normal)
        homeButton.tintColor = .white
        
        actorPosterImageView.layer.cornerRadius = 6
        actorPosterImageView.addWhiteShadow()
        actorPosterImageView.contentMode = .scaleAspectFill
        
        nameLabel.textAlignment = .left
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        nameLabel.numberOfLines = 0
        
        birthdayLabel.numberOfLines = 0
        birthdayLabel.textAlignment = .left
        
        biographyLabel.numberOfLines = 0
        birthdayLabel.textAlignment = .justified
        
        IMDBButton.backgroundColor = .clear
        IMDBButton.setImage(UIImage(named: "imdbLogo"), for: .normal)
        IMDBButton.tintColor = .white
        
        webSiteButton.setImage(UIImage(named: "web"), for: .normal)
        webSiteButton.tintColor = .black
        webSiteButton.layer.cornerRadius = 12
        webSiteButton.layer.masksToBounds = true
        webSiteButton.backgroundColor = .lightGray
        
    }
    
    private func setLayout() {
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        scrollView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.scrollView)
            make.left.right.equalTo(view)
        }
        
        mainView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.mainView.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.mainView.snp.leading).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(25)
        }
        
        mainView.addSubview(homeButton)
        homeButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.backButton.snp.centerY)
            make.trailing.equalTo(self.mainView.snp.trailing).offset(-20)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        mainView.addSubview(actorPosterImageView)
        actorPosterImageView.snp.makeConstraints { make in
            make.top.equalTo(self.backButton.snp.bottom).offset(10)
            make.leading.equalTo(self.mainView.snp.leading).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(180)
        }
        
        mainView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.actorPosterImageView.snp.top)
            make.leading.equalTo(self.actorPosterImageView.snp.trailing).offset(20)
            make.trailing.equalTo(self.mainView.snp.trailing).offset(-20)
        }
        
        mainView.addSubview(birthdayLabel)
        birthdayLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self.nameLabel)
        }
        
        mainView.addSubview(IMDBButton)
        IMDBButton.snp.makeConstraints { make in
            make.top.equalTo(self.actorPosterImageView.snp.bottom).offset(10)
            make.leading.equalTo(self.actorPosterImageView.snp.leading)
            make.width.equalTo(49)
            make.height.equalTo(24)
        }
        
        mainView.addSubview(webSiteButton)
        webSiteButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.actorPosterImageView.snp.trailing)
            make.height.width.equalTo(24)
            make.centerY.equalTo(self.IMDBButton.snp.centerY)
        }
        
        mainView.addSubview(biographyLabel)
        biographyLabel.snp.makeConstraints { make in
            make.top.equalTo(self.IMDBButton.snp.bottom).offset(15)
            make.leading.equalTo(self.mainView.snp.leading).offset(10)
            make.trailing.equalTo(self.mainView.snp.trailing).offset(-10)
            make.height.greaterThanOrEqualTo(0)
        }
        
        mainView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.biographyLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self.mainView)
            make.height.equalTo(140)
            make.bottom.equalTo(self.mainView.snp.bottom).offset(-15)
        }
        
    }

}

//MARK: - CollectionView Properties
extension ActorDetailScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: ActorCastCollectionViewCell.nibName, bundle: nil),
                                forCellWithReuseIdentifier: ActorCastCollectionViewCell.identifier)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getRowCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.getCollectionViewCell(collectionview: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 130)
    }
        
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
        
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = MovieDetailScreenViewController()
        nextVC.viewModel.movieID = viewModel.getMovieID(index: indexPath.row)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
