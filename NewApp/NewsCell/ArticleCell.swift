//
//  ArticleCell.swift
//  NewApp
//
//  Created by Artsiom Habruseu on 5.03.21.
//

import UIKit
import Kingfisher


protocol ArticleCellDelegate: class {
    func showMoreButtonDidTap(_ cell: ArticleCell)
}


class ArticleCell: UITableViewCell {
    
    // MARK: - Identifier
    
    
    static let cellIdentifier = "ArticleCell"
    
    
    // MARK: - Delegate
    
    
    weak var delegate: ArticleCellDelegate?
    
    
    // MARK: - Outlets
    
    
    @IBOutlet private var articleImageView: UIImageView!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var showMoreButton: UIButton!
    
    
    // MARK: - Properties
    
    
    private var article: Article?
    private var isInitialShowMoreButtonUpdate = true
    
    
    // MARK: - Overrides
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShowMoreButtonVisibility()
    }
    
    
    // MARK: - Actions
    
    
    @IBAction private func showMoreButtonDidTap() {
        delegate?.showMoreButtonDidTap(self)
    }
    
    
    // MARK: - Methods
    
    
    func setArticle(_ article: Article?) {
        self.article = article
        updateArticleImageViewImage()
        updateDescriptionLabelText()
    }
    
    
    func updateToExpanded(_ isExpanded: Bool) {
        descriptionLabel.numberOfLines = isExpanded ? 0 : 3
        showMoreButton.setTitle(isExpanded ? "Show less" : "Show more", for: .normal)
    }
    
    
    // MARK: - Private
    
    
    private func updateArticleImageViewImage() {
        guard let urlString = article?.urlToImage,
              let url = URL(string: urlString)
        else {
            articleImageView?.image = UIImage(named: "placeholder") ?? UIImage()
            return
        }
        articleImageView.kf.indicatorType = .activity
        articleImageView.kf.setImage(with: url)
    }
    
    
    private func updateDescriptionLabelText() {
        guard let description = article?.description else { return }
        descriptionLabel.text = description
    }
    
    
    private func updateShowMoreButtonVisibility() {
        guard isInitialShowMoreButtonUpdate else { return }
        showMoreButton.isHidden = !checkIsDescriptionLabelTruncated()
        isInitialShowMoreButtonUpdate = false
    }
    
    
    private func checkIsDescriptionLabelTruncated() -> Bool {
        countDescriptionLabelLines() > 3
    }
    
    
    private func countDescriptionLabelLines() -> Int {
        layoutIfNeeded()
        let myText = descriptionLabel.text! as NSString
        let rect = CGSize(width: descriptionLabel.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [.font: descriptionLabel.font!], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / descriptionLabel.font.lineHeight))
    }
    
}
