import UIKit

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct ReviewCellConfig {

    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: ReviewCellConfig.self)
    
    let ratingRenderer: RatingRenderer
    ///Рейтинг пользователч
    let rating: Int
    ///Имя пользователя
    let userName: String
    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
    /// Текст отзыва.
    let reviewText: NSAttributedString
    /// Максимальное отображаемое количество строк текста. По умолчанию 3.
    var maxLines = 3
    /// Время создания отзыва.
    let created: NSAttributedString
    /// Замыкание, вызываемое при нажатии на кнопку "Показать полностью...".
    let onTapShowMore: (UUID) -> Void
    ///Аватарка пользователя
    let avatar_url: String?
    ///Фото пользователя
    let photo_urls: [String]?

    /// Объект, хранящий посчитанные фреймы для ячейки отзыва.
    fileprivate let layout = ReviewCellLayout()

}

// MARK: - TableCellConfig

extension ReviewCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCell else { return }
        let starsImage = ratingRenderer.ratingImage(rating)

        cell.ratingImageView.image = starsImage
        
        cell.userNameLabel.text = userName
        cell.reviewTextLabel.attributedText = reviewText
        cell.reviewTextLabel.numberOfLines = maxLines
        cell.createdLabel.attributedText = created
        cell.config = self
    }

    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }

}

// MARK: - Private

private extension ReviewCellConfig {

    /// Текст кнопки "Показать полностью...".
    static let showMoreText = "Показать полностью..."
        .attributed(font: .showMore, color: .showMore)

}

// MARK: - Cell

final class ReviewCell: UITableViewCell {

    fileprivate var config: Config?
    
    fileprivate let ratingImageView = UIImageView()
    fileprivate let userNameLabel = UILabel()
    fileprivate let avatarImageView = UIImageView()
    fileprivate let reviewTextLabel = UILabel()
    fileprivate let createdLabel = UILabel()
    fileprivate let showMoreButton = UIButton()

    required init?(coder: NSCoder) {
        assertionFailure("Этот экран нельзя создавать через Storyboard!")
        return nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        ratingImageView.frame = layout.ratingImageViewFrame
        userNameLabel.frame = layout.userNameLabelFrame
        avatarImageView.frame = layout.avatarImageViewFrame
        reviewTextLabel.frame = layout.reviewTextLabelFrame
        createdLabel.frame = layout.createdLabelFrame
        showMoreButton.frame = layout.showMoreButtonFrame
    }
//MARK: - Action

@objc private func didTapShowMore() {
    guard let config = config else { return }
    config.onTapShowMore(config.id)
}

}

// MARK: - Private

private extension ReviewCell {

    func setupCell() {
        
        setupRatingImageView()
        setupUserNameLabel()
        setupAvatarImage()
        setupReviewTextLabel()
        setupCreatedLabel()
        setupShowMoreButton()
    }
    
    func setupRatingImageView() {
        contentView.addSubview(ratingImageView)
        ratingImageView.contentMode = .left
    }

    
    func setupUserNameLabel() {
        contentView.addSubview(userNameLabel)
        userNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        userNameLabel.textColor = .black
    }

    func setupAvatarImage() {
        contentView.addSubview(avatarImageView)
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = ReviewCellLayout.avatarCornerRadius
        avatarImageView.layer.masksToBounds = true
        
        if let avatarURL = config?.avatar_url, !avatarURL.isEmpty {
            loadImageCached(from: avatarURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.avatarImageView.image = image ?? UIImage(named: "avatar")
                }
            }
        }
    }

    func setupReviewTextLabel() {
        contentView.addSubview(reviewTextLabel)
        reviewTextLabel.lineBreakMode = .byWordWrapping
    }

    func setupCreatedLabel() {
        contentView.addSubview(createdLabel)
    }

    func setupShowMoreButton() {
        contentView.addSubview(showMoreButton)
        showMoreButton.contentVerticalAlignment = .fill
        showMoreButton.setAttributedTitle(Config.showMoreText, for: .normal)
        showMoreButton.addTarget(self, action: #selector(didTapShowMore), for: .touchUpInside)
    }

}

// MARK: - Layout

/// Класс, в котором происходит расчёт фреймов для сабвью ячейки отзыва.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewCellLayout {

    // MARK: - Размеры

    fileprivate static let avatarSize = CGSize(width: 36.0, height: 36.0)
    fileprivate static let avatarCornerRadius = 18.0
    fileprivate static let photoCornerRadius = 8.0

    private static let photoSize = CGSize(width: 55.0, height: 66.0)
    private static let showMoreButtonSize = Config.showMoreText.size()

    // MARK: - Фреймы

    private(set) var ratingImageViewFrame = CGRect.zero
    private(set) var userNameLabelFrame = CGRect.zero
    private(set) var avatarImageViewFrame = CGRect.zero
    private(set) var reviewTextLabelFrame = CGRect.zero
    private(set) var showMoreButtonFrame = CGRect.zero
    private(set) var createdLabelFrame = CGRect.zero

    // MARK: - Отступы

    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)

    /// Горизонтальный отступ от аватара до имени пользователя.
    private let avatarToUsernameSpacing = 10.0
    /// Вертикальный отступ от имени пользователя до вью рейтинга.
    private let usernameToRatingSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до текста (если нет фото).
    private let ratingToTextSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до фото.
    private let ratingToPhotosSpacing = 10.0
    /// Горизонтальные отступы между фото.
    private let photosSpacing = 8.0
    /// Вертикальный отступ от фото (если они есть) до текста отзыва.
    private let photosToTextSpacing = 10.0
    /// Вертикальный отступ от текста отзыва до времени создания отзыва или кнопки "Показать полностью..." (если она есть).
    private let reviewTextToCreatedSpacing = 6.0
    /// Вертикальный отступ от кнопки "Показать полностью..." до времени создания отзыва.
    private let showMoreToCreatedSpacing = 6.0

    // MARK: - Расчёт фреймов и высоты ячейки

    /// Возвращает высоту ячейку с данной конфигурацией `config` и ограничением по ширине `maxWidth`.
    func height(config: Config, maxWidth: CGFloat) -> CGFloat {

        avatarImageViewFrame = CGRect(x: insets.left,
                                      y: insets.top,
                                      width: Self.avatarSize.width,
                                      height: Self.avatarSize.height)
        let textOriginX = insets.left + Self.avatarSize.width + avatarToUsernameSpacing
        let textAvailableWidth = maxWidth - insets.right - textOriginX
        
        var maxY = insets.top
        var showShowMoreButton = false
        
        userNameLabelFrame = CGRect(x: textOriginX,
                                    y: insets.top,
                                    width: textAvailableWidth,
                                    height: 20)
        
        maxY = userNameLabelFrame.maxY + usernameToRatingSpacing

        ratingImageViewFrame = CGRect(x: textOriginX,
                                      y: userNameLabelFrame.maxY + 4,
                                      width: 100,
                                      height: 16
        )
        maxY = ratingImageViewFrame.maxY + 8

    
        if !config.reviewText.isEmpty() {
            // Высота текста с текущим ограничением по количеству строк.
            let currentTextHeight = (config.reviewText.font()?.lineHeight ?? .zero) * CGFloat(config.maxLines)
            // Максимально возможная высота текста, если бы ограничения не было.
            let actualTextHeight = config.reviewText.boundingRect(width: textAvailableWidth).size.height
            // Показываем кнопку "Показать полностью...", если максимально возможная высота текста больше текущей.
            showShowMoreButton = config.maxLines != .zero && actualTextHeight > currentTextHeight

            reviewTextLabelFrame = CGRect(
                origin: CGPoint(x: textOriginX, y: maxY),
                size: config.reviewText.boundingRect(width: textAvailableWidth, height: currentTextHeight).size
            )
            maxY = reviewTextLabelFrame.maxY + reviewTextToCreatedSpacing
        }

        if showShowMoreButton {
            showMoreButtonFrame = CGRect(
                origin: CGPoint(x: textOriginX, y: maxY),
                size: Self.showMoreButtonSize
            )
            maxY = showMoreButtonFrame.maxY + showMoreToCreatedSpacing
        } else {
            showMoreButtonFrame = .zero
        }

        createdLabelFrame = CGRect(
            origin: CGPoint(x: textOriginX, y: maxY),
            size: config.created.boundingRect(width: textAvailableWidth).size
        )
        
        let textMaxY = createdLabelFrame.maxY
        
        let cellHeight = max(avatarImageViewFrame.maxY, textMaxY) + insets.bottom
        return cellHeight
    }

}

// MARK: - Typealias

fileprivate typealias Config = ReviewCellConfig
fileprivate typealias Layout = ReviewCellLayout


