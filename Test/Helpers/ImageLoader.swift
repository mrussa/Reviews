import UIKit

final class ImageCache {

    static let shared = ImageCache()
    
    /// NSCache кэш-словарь, ключ типа NSURL, значение UIImage. Он автоматически управляет особождением папяти
    private let cache = NSCache<NSURL, UIImage>()
    ///Доступен только один экземляр - shared. Второй экземпляр нельзя создавать
    private init() {}
    
    ///Метод для получения изображения из кэша
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    ///Метод для сохранения изображения в кэш, привязка к URL
    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

///Функция для асинхронной загрузки изображения
func loadImageCached(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }
    
    ///Провека есть ли изображение в кэше
    if let cached = ImageCache.shared.image(for: url) {
        completion(cached)
        return
    }
    
    ///Загружаем по сети, если нет
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        
        guard let data = data,
              let image = UIImage(data: data) else {
            completion(nil)
            return
        }
        
        ImageCache.shared.setImage(image, for: url)
        completion(image)
    }
    
    task.resume()
 }

