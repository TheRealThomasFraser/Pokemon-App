import Foundation

struct Pokemon: Decodable {
    let name: String
    let sprites: Sprites
    let types: [PokemonType]

    struct Sprites: Decodable {
        let frontDefault: String

        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }

    struct PokemonType: Decodable {
        let type: TypeDetail
    }

    struct TypeDetail: Decodable {
        let name: String
    }

    struct Species: Decodable {
        let url: String
    }
}

