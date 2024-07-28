import Foundation

struct PokemonListResponse: Decodable {
    let results: [PokemonListItem]
    let next: String?
}

struct PokemonListItem: Decodable, Identifiable {
    let id = UUID()
    let name: String
    let url: String
    var imageUrl: String?
}


