import UIKit

///Ячейка для количества отзывов
struct ReviewCountCellConfig: TableCellConfig {

    ///Общее количество отзывов
    let totalCount: Int
    
    ///Идентификатор для регистрации ячейки
    var reuseId: String {
        String(describing: Self.self)
    }
    
    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCountCell else { return }
        cell.countLabel.text = "\(totalCount) отзывов"
    }
    
    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        44
    }
}

// MARK: - Cell

final class ReviewCountCell: UITableViewCell {
    
    fileprivate let countLabel = UILabel()
    
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
        countLabel.frame = contentView.bounds.insetBy(dx: 16, dy: 8)
    
    }

}

// MARK: - Private

private extension ReviewCountCell {
    
    func setupCell() {
        setupCountLabel()
    }
    
    func setupCountLabel() {
        contentView.addSubview(countLabel)
        countLabel.textAlignment = .center
        countLabel.font = .systemFont(ofSize: 15, weight: .medium)
        countLabel.textColor = .secondaryLabel
    }
    
}
