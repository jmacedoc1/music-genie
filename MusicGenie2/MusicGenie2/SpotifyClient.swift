//
//  SpotifyClient.swift
//  MusicGenie2
//
//  Created by Josemaría Macedo Carrillo on 3/6/24.
//

/*
 Resources:
 - Code from Assignment 3 "GitHub Issues" from iOS Application Development course by Josemaria Macedo.
 - https://developer.spotify.com/documentation/web-api/reference/get-list-users-playlists
 - https://developer.spotify.com/documentation/web-api/reference/get-playlists-tracks
 */

import Foundation

// Playlist structures
struct PlaylistImage: Codable {
    let height: Int?
    let url: String?
    let width: Int?
}

struct TracksAPI: Codable {
    let href: String?
}

struct SpotifyPlaylist: Codable {
    let id: String?
    let images: [PlaylistImage]?
    let name: String?
    let tracks: TracksAPI?
}

struct PlaylistItems: Codable {
    let items: [SpotifyPlaylist]
}


// Tracks structures
struct SpotifyAlbum: Codable {
    let images: [PlaylistImage]?
    let name: String?
}

struct SpotifyArtist: Codable {
    let name: String?
}

struct TrackInfo: Codable {
    let album: SpotifyAlbum?
    let artists: [SpotifyArtist]?
    let name: String?
}

struct SpotifyTrack: Codable {
    let track: TrackInfo?
}

struct TrackItems: Codable {
    let items: [SpotifyTrack]
}

class SpotifyClient {
    
    enum PlaylistFetcherError: Error {
        case invalidURL
        case badResponse
    }
    
    func fetchPlaylists() async throws -> PlaylistItems {
        let url_str = "https://api.spotify.com/v1/me/playlists"
        
        guard let url = URL(string: url_str) else {
            throw PlaylistFetcherError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let userToken = UserDefaults.standard.string(forKey: "AccessToken")
        let tokenBearerString = "Bearer \(userToken ?? "")"
        request.allHTTPHeaderFields = ["Authorization": tokenBearerString]
        
        // Use the async variant of URLSession to fetch data
        let (data, response) = try await URLSession.shared.data(for: request)
  
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw PlaylistFetcherError.badResponse
        }
        
//        print("Response: \(response)")
//        print("JSON data: \(data)")
        
        // Parse the JSON data
//        print("Playlist items before decoding: \(PlaylistItems.self)")
        let decodedPlaylists = try JSONDecoder().decode(PlaylistItems.self, from: data)
//        print("decodedPlaylists: \(decodedPlaylists)")
        return decodedPlaylists
    }
}

