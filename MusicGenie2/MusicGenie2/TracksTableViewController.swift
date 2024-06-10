//
//  TracksTableViewController.swift
//  MusicGenie2
//
//  Created by Josemaría Macedo Carrillo on 3/6/24.
//

/*
 Resources:
 - Code from Assignment 3 "GitHub Issues" from iOS Application Development course by Josemaria Macedo.
 -  https://developer.spotify.com/documentation/web-api/reference/get-playlists-tracks
 - https://github.com/mandepudichaitanya9/Multiple-Rows-Selection/blob/main/MultipleRowsSelection/MultipleRowsSelection/ViewController.swift
 */

import UIKit

class TracksTableViewController: UITableViewController {
    var selectedIssue: SpotifyPlaylist?
    var tracks: [SpotifyTrack] = []
    var unselectedCells:[Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a navigation bar
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))

        // Create a navigation item
        let navigationItem = UINavigationItem()
        navigationItem.title = "Test title"

        // Optionally customize the appearance of the navigation bar
        navigationBar.barTintColor = UIColor.systemBlue
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        // Set the navigation item to the navigation bar
        navigationBar.items = [navigationItem]

        // Set the navigation bar as the title view
        self.navigationItem.titleView = navigationBar
        
        // Assuming navigation bar height is 44, adjust the table view frame
        let navigationBarHeight: CGFloat = 44
            tableView.frame = CGRect(x: 0, y: navigationBarHeight, width: view.frame.width, height: view.frame.height - navigationBarHeight)
        
        Task {
            do {
                // Assign the JSON text
                let playlistURL = UserDefaults.standard.string(forKey: "PlaylistURL")
                print("Playlist URL called in TracksTableViewController is: \(playlistURL ?? "No playlist URL found in User Defaults")")
                tracks = try await self.fetchTracks(url_str: playlistURL!).items
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tracks.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackTableViewCell

        // Configure the cell...
        let track = tracks[indexPath.row]
//        cell.playlistImage.image = playlist.images
        
        if let trackName = track.track?.name {
            print("Track Name: \(trackName)")
            cell.song?.text = trackName
            cell.song?.textColor = UIColor.black
        } else {
            print("Track Name is nil")
            cell.song?.text = "Unknown Track"
        }
        
        var artistStr = ""
        let artists = track.track?.artists
        
        if let artists = artists {
            if artists.count > 1 {
                for artist in artists {
                    artistStr += artist.name! + ", "
                }
            } else {
                artistStr = artists[0].name!
                // Handle the case where artists is nil (optional is not unwrapped)
            }
        } else {
            print("Artists array is nil.")
        }

        cell.artist?.text = artistStr
//        cell.checkmark?.image = UIImage(systemName: "circle")
        cell.checkmark?.image = self.unselectedCells.contains(indexPath.row) ? UIImage(systemName: "circle") : UIImage(systemName: "checkmark.circle.fill")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.unselectedCells.contains(indexPath.row) {
            let index = self.unselectedCells.firstIndex(of: indexPath.row)
            self.unselectedCells.remove(at: index!)
            print("Removed row \(indexPath.row) from unselected cells array.")
            print("Array: \(self.unselectedCells)")
        }else {
            self.unselectedCells.append(indexPath.row)
            print("Added row \(indexPath.row) to unselected cells array.")
            print("Array: \(self.unselectedCells)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Networking
    enum TrackFetcherError: Error {
        case invalidURL
        case badResponse
    }
    
    func fetchTracks(url_str: String) async throws -> TrackItems {
        
        guard let url = URL(string: url_str) else {
            throw TrackFetcherError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let userToken = UserDefaults.standard.string(forKey: "AccessToken")
        let tokenBearerString = "Bearer \(userToken ?? "")"
        request.allHTTPHeaderFields = ["Authorization": tokenBearerString]
        
        let (data, response) = try await URLSession.shared.data(for: request)
  
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw TrackFetcherError.badResponse
        }
        
//        print("Response: \(response)")
//        print("JSON data: \(data)")
        
        // Parse the JSON data
//        print("Playlist items before decoding: \(PlaylistItems.self)")
        let decodedTracks = try JSONDecoder().decode(TrackItems.self, from: data)
//        print("decodedTracks: \(decodedTracks)")
        return decodedTracks
    }

}
