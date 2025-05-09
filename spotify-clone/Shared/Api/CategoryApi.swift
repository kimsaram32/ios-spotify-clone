import Foundation

class CategoryApi: BaseApi {
    
    static let shared = CategoryApi()
    
    private override init() {}
    
    func getCategories() async throws -> [Category] {
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/browse/categories")!
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: "50"),
        ]
        guard let request = await createAuthorizedURLRequest(url: urlComponents.url!) else {
            throw ApiError.unAuthorized
        }
        
        do {
            let (rawData, _) = try await URLSession.shared.data(for: request)
            let data = try JSONDecoder().decode(CategoriesResponse.self, from: rawData)
            return data.categories.items
        } catch {
            print(error)
            throw ApiError.requestFailed
        }
    }
    
}
