//
//  PlaylistsViewController.swift
//  MusicGenie2
//
//  Created by Josemaría Macedo Carrillo on 3/6/24.
//

/*
 Resources:
 - Code from Assignment 3 "GitHub Issues" from iOS Application Development course by Josemaria Macedo.
 */

import UIKit

class PlaylistsViewController: UITableViewController {
    
    let spotifyclient = SpotifyClient()
    var playlists: [SpotifyPlaylist] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                // Assign the JSON text
                playlists = try await spotifyclient.fetchPlaylists().items
                
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
        return playlists.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlaylistTableViewCell

        // Configure the cell...
        let playlist = playlists[indexPath.row]
//        cell.playlistImage.image = playlist.images
        
        if let playlistName = playlist.name {
            print("Playlist Name: \(playlistName)")
            cell.playlistName?.text = playlistName
            cell.playlistName?.textColor = UIColor.black
        } else {
            print("Playlist Name is nil")
            cell.playlistName?.text = "Unknown Playlist"
        }

        return cell
    }


    // MARK: - Delegate Methods

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let currentIndex: IndexPath = tableView!.indexPathForSelectedRow!

        if (segue.identifier == "toTracks") {
            let vc = segue.destination as! TracksTableViewController
            vc.selectedIssue = self.playlists[currentIndex.row]
            let playlistURL = vc.selectedIssue?.tracks?.href
            UserDefaults.standard.set(playlistURL, forKey: "PlaylistURL")
        }
    }

}
