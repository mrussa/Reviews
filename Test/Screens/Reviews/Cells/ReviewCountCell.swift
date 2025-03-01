import Foundation

///Ячейка для количества отзывов
struct ReviewCountCellConfig: TableCellConfig {

    ///Общее количество отзывов
    let totalCount: Int
    
    ///Идентификатор для регистрации ячейки
    var reuseId: String {
        String(describing: Self.self)
    }
    
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCountCell else { return }
    }
}
