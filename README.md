# README

## 1. Убраны `fatalError()` (заменены на `assertionFailure()`)
Ранее в коде при инициализации некоторых вью-контроллеров и вью использовался `fatalError`.  
- `fatalError` безусловно завершает приложение, что неприемлемо для реальных пользователей.  
- Теперь вместо этого стоит `assertionFailure(...)`, который **не** крашит приложение в продакшене, но предупредит разработчика при отладке.

---

## 2. Настройка аватара
- Добавлен `avatarImageView` размером 36×36 (квадрат), со скруглёнными краями (`avatarCornerRadius = 18`).
- Изображение из Assets теперь называется `avatar` вместо `l5w5aIHioYc`.
- У аватара включён `contentMode = .scaleAspectFill` и `layer.masksToBounds = true`, чтобы изображение корректно обрезалось по круглой форме.
  
---

## 3. Добавление имени пользователя
- Добавлено в модель отзыва `Review`.
```swift
    ///Имя и фамилия пользователя отзыва.
    let first_name: String
    let last_name: String.
```
- Добавлено в модель отзыва `ReviewsViewModel`.
```swift
  let fullName = "\(review.first_name) \(review.last_name)"
  userName: fullName,
```
- Добавлено в ячейку отзыва `ReviewCell`. И установлены фреймы и настроен внешний вид. 
  
---

## 4. Настройка изображения рейтинга пользователя
- Добавлено в модель отзыва `Review`.
- Добавлено в `ReviewsViewModel`.
- Добавлено в ячейку отзыва `ReviewCell`. И установлены фреймы и настроен внешний вид.
  
---  

## 5. Настройка изображения рейтинга пользователя
- Создаем файл `ReviewCountCell` в папке `Cell`.
- Создаем конфигурацию и класс ячейки `ReviewCountCell`.
- Регистрируем ячейку в `setupTableView`.
- Добавлено в метод обработки получения отзывов в массив `ReviewsViewModel`.
  
---

## 6. Утечки памяти
- Запускаем Instruments.
- На графе видно `retain cycle` в `ReviewsViewModel`.
- В `ReviewsViewModel` содержит `state` - сильная сслылка; `state.items` содержит `ReviewCellConfig`; `ReviewCellConfig` содержит сильную сслыку обратно на `ReviewsViewModel`.
- Меняем код
```swift
  onTapShowMore: showMoreReview 
```
на замыкание с [weak self]
```swift
onTapShowMore: { [weak self] id in
  self?.showMoreReview(with: id)
}
```
---  

## 7. Плавность скроллинга
- Открыть `Instruments`. Выбрать `Animation Hitches`.
- Так как для каждой ячеки вручную рассчитывается высота через `boundingRect`, то кэшируем результаты высоты для каждого id.
  
---

## 8. Airbnb's Swift Style Guide & API Design Guidelines
- CamelCase.
- Понятные названия и самодокументирующие.
- Писать явно, не слишком сокращать.
- Добавлены комментарии.
  
---

## 9. Кнопка показать полностью без анимации
- Добавляем действие `didTapShowMore` в `setupShowMoreButton`. 
- Добавляем `UIView.performWithoutAnimation`, чтобы было без анимации.
- Не забываем сбрасывать кэш высоты `cacheHeight[id] = nil` в методе `showMoreReview`.
  
---

## 10. Добавление `avatar_url` и/или `photo_urls`
- Добавляем для каждого пользователя ссылки в json файл. 
- Обновляем модель Review `Review`. Используем optional, картинки может не быть.
- Создаем файл `ImageLoader` в папке `Helpers` для асинхронной загрузки изображений.
- Добавляем кеширование `NSCache`.
- В методе `setupAvatarImage` вызываем для загрузки аватара 
  
---

## 11. Фото и видео

<img width="257" alt="Снимок экрана 2025-03-02 в 13 34 00" src="https://github.com/user-attachments/assets/2dbdf302-3ca9-42c6-bb88-dbe96b7fc8ab" />

<img width="257" alt="Снимок экрана 2025-03-02 в 13 34 31" src="https://github.com/user-attachments/assets/f1f121da-cefa-4515-bccb-77569fa58102" />

https://github.com/user-attachments/assets/6e6f17b0-7547-4257-af2b-43e86dc24e3c


