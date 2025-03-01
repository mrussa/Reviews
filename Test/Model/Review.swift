/// Модель отзыва.
struct Review: Decodable {
    ///Рейтинг отзыва
    let rating: Int
    ///Имя и фамилия пользователя отзыва.
    let first_name: String
    let last_name: String

    /// Текст отзыва.
    let text: String
    /// Время создания отзыва.
    let created: String

}
