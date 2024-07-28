import SwiftUI

struct PokedexView: View {
    @StateObject private var viewModel = PokedexViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.pokemonList) { pokemon in
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                        HStack {
                            if let imageUrl = pokemon.imageUrl, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    } else if phase.error != nil {
                                        Image(systemName: "xmark.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.red)
                                    } else {
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            } else {
                                Image(systemName: "questionmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            Text(pokemon.name.capitalized)
                                .padding(.leading, 10)
                        }
                    }
                }
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    Button(action: {
                        viewModel.fetchPokemonList()
                    }) {
                        Text("Load More")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Pokédex")
            .onAppear {
                viewModel.fetchPokemonList()
            }
        }
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
    }
}

