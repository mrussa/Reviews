import UIKit

final class ReviewsView: UIView {

    let tableView = UITableView()

    required init?(coder: NSCoder) {
        assertionFailure("Этот экран нельзя создавать через Storyboard!")
        return nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds.inset(by: safeAreaInsets)
    }

}

// MARK: - Private

private extension ReviewsView {

    func setupView() {
        backgroundColor = .systemBackground
        setupTableView()
    }

    func setupTableView() {
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCellConfig.reuseId)
        tableView.register(ReviewCountCell.self, forCellReuseIdentifier: ReviewCountCellConfig.reuseId)
    }

}
