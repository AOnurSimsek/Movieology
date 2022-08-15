//
//  MovieDetailScreen.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 12.08.2022.
//

import UIKit
import SnapKit
import SafariServices

final class MovieDetailScreenViewController: BaseViewController<MovieDetailViewModel> {
    
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var mainView: UIView = UIView()
    private lazy var backButton: UIButton = UIButton()
    private lazy var homeButton: UIButton = UIButton()
    private lazy var backdropImageView: UIImageView = UIImageView()
    private lazy var videoButton: UIButton = UIButton()
    private lazy var posterImageView: UIImageView = UIImageView()
    private lazy var webSiteButton: UIButton = UIButton()
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var voteLabel: UILabel = UILabel()
    private lazy var voteIcon: UIImageView = UIImageView()
    private lazy var IMDBButton: UIButton = UIButton()
    private lazy var genreLabel: UILabel = UILabel()
    private lazy var releaseDateLabel: UILabel = UILabel()
    private lazy var runtimeLabel: UILabel = UILabel()
    private lazy var castTitleLabel: UILabel = UILabel()
    private lazy var overViewLabel: UILabel = UILabel()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                         collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bind()
        addTargets()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading()
        viewModel.getDetails()
        
    }
    
    private func bind() {
        viewModel.movieDetails.bind { [weak self] _ in
            guard let self = self
            else { return }
            self.viewModel.getImage(to: self.backdropImageView, imageType: .backdrop)
            self.viewModel.getImage(to: self.posterImageView, imageType: .poster)
            self.titleLabel.text = self.viewModel.getText(type: .title)
            self.overViewLabel.text = self.viewModel.getText(type: .overview)
            self.voteLabel.text = self.viewModel.getText(type: .vote)
            self.genreLabel.attributedText = self.viewModel.getAttributedText(type: .genres)
            self.overViewLabel.attributedText = self.viewModel.getAttributedText(type: .overview)
            self.releaseDateLabel.attributedText = self.viewModel.getAttributedText(type: .releasedate)
            self.runtimeLabel.attributedText = self.viewModel.getAttributedText(type: .runtime)
            self.removeLoading()
        }
        
        viewModel.error.bind { [weak self] _error in
            if let error = _error {
                self?.showAlert(error)
                self?.removeLoading()
            }
        }
        
        viewModel.movieCredits.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.movieVideos.bind { [weak self] _value in
            if _value != nil {
                self?.videoButton.isHidden = false
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
        videoButton.addTarget(self, action: #selector(gotoVideos), for: .touchUpInside)
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
    
    @objc func gotoVideos() {
        openWeb(type: .videos)
    }
    
    @objc func gotoImdb() {
        openWeb(type: .imdb)
    }
    
}

//MARK: - UI and Layout
extension MovieDetailScreenViewController {
    private func setUI() {
        self.view.backgroundColor = UIColor(hexString: "071037")
        
        scrollView.bounces = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false

        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.addWhiteShadow()
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.addWhiteShadow()
        
        webSiteButton.setImage(UIImage(named: "web"), for: .normal)
        webSiteButton.tintColor = .black
        webSiteButton.layer.cornerRadius = 20
        webSiteButton.layer.masksToBounds = true
        webSiteButton.backgroundColor = .lightGray
        webSiteButton.layer.zPosition = 2
        
        videoButton.setImage(UIImage(named: "play"), for: .normal)
        videoButton.tintColor = .white
        videoButton.layer.cornerRadius = 25
        videoButton.layer.masksToBounds = true
        videoButton.backgroundColor = .red
        videoButton.layer.zPosition = 2
        videoButton.isHidden = true
        
        backButton.backgroundColor = .clear
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.tintColor = .white
        backButton.layer.zPosition = 2
        
        homeButton.backgroundColor = .clear
        homeButton.setImage(UIImage(named: "homeIcon"), for: .normal)
        homeButton.tintColor = .white
        homeButton.layer.zPosition = 2
        
        IMDBButton.backgroundColor = .clear
        IMDBButton.setImage(UIImage(named: "imdbLogo"), for: .normal)
        IMDBButton.tintColor = .white
        
        voteIcon.image = UIImage(named: "rateIcon")
        
        voteLabel.textColor = .white
        voteLabel.font = UIFont(name: "Roboto-Medium", size: 20)
        voteLabel.textAlignment = .left
        
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 24)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        
        overViewLabel.numberOfLines = 0
        overViewLabel.textAlignment = .justified
        
        genreLabel.numberOfLines = 0
        genreLabel.textAlignment = .left
        
        castTitleLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        castTitleLabel.textAlignment = .left
        castTitleLabel.text = "Cast:"
        castTitleLabel.textColor = .white
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
            make.height.greaterThanOrEqualTo(self.view.snp.height)
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
        
        mainView.addSubview(backdropImageView)
        backdropImageView.snp.makeConstraints { make in
            make.top.equalTo(self.mainView)
            make.leading.trailing.equalTo(self.mainView)
            let screenWith = UIScreen.main.bounds.width
            make.height.equalTo(screenWith/1.7793)
        }
        
        mainView.addSubview(videoButton)
        videoButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.mainView.snp.trailing).offset(-10)
            make.bottom.equalTo(self.backdropImageView.snp.bottom).offset(-10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        mainView.addSubview(webSiteButton)
        webSiteButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.videoButton.snp.leading).offset(-8)
            make.height.width.equalTo(40)
            make.centerY.equalTo(self.videoButton.snp.centerY)
        }
        
        mainView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.mainView.snp.leading).offset(20)
            make.centerY.equalTo(self.backdropImageView.snp.bottom)
            make.width.equalTo(80)
            make.height.equalTo(120)
        }
        
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.backdropImageView.snp.bottom).offset(10)
            make.leading.equalTo(self.posterImageView.snp.trailing).offset(15)
            make.trailing.equalTo(self.mainView.snp.trailing).offset(-15)
        }
        
        mainView.addSubview(IMDBButton)
        IMDBButton.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.titleLabel.snp.leading)
            make.width.equalTo(49)
            make.height.equalTo(24)
        }
        
        mainView.addSubview(voteIcon)
        voteIcon.snp.makeConstraints { make in
            make.centerY.equalTo(self.IMDBButton.snp.centerY)
            make.leading.equalTo(self.IMDBButton.snp.trailing).offset(8)
            make.height.width.equalTo(18)
        }
        
        mainView.addSubview(voteLabel)
        voteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.IMDBButton.snp.centerY)
            make.height.equalTo(18)
            make.leading.equalTo(self.voteIcon.snp.trailing).offset(8)
        }
        
        mainView.addSubview(genreLabel)
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(self.IMDBButton.snp.bottom).offset(20)
            make.leading.equalTo(self.mainView.snp.leading).offset(15)
            make.trailing.equalTo(self.mainView.snp.trailing).offset(-15)
        }
        
        mainView.addSubview(runtimeLabel)
        runtimeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.genreLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(genreLabel)
        }
        mainView.addSubview(releaseDateLabel)
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.runtimeLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(genreLabel)
        }
        
        mainView.addSubview(overViewLabel)
        overViewLabel.snp.makeConstraints { make in
            make.top.equalTo(self.releaseDateLabel.snp.bottom).offset(15)
            make.leading.equalTo(self.genreLabel.snp.leading)
            make.trailing.equalTo(self.genreLabel.snp.trailing)
        }
        
        mainView.addSubview(castTitleLabel)
        castTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.overViewLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self.genreLabel)
        }
        
        mainView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.castTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self.mainView)
            make.height.equalTo(200)
            make.bottom.greaterThanOrEqualTo(self.mainView.snp.bottom).offset(-15)
        }
        
    }
    
}

//MARK: - CollectionView Properties
extension MovieDetailScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: CastCollectionViewCell.nibName, bundle: nil),
                                forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
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
        return viewModel.getCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
        
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
        
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.getActorID(index: indexPath.row)
        let nextVC = ActorDetailScreenViewController()
        nextVC.viewModel.actorID = id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
