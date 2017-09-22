# -*- coding: utf-8 -*-
"""
Created on Wed Sep 20 19:40:28 2017

@author: caris
"""

import spotipy
import sys
import pprint
from spotipy.oauth2 import SpotifyClientCredentials
import os
import subprocess
import spotipy.util as util
import json
import csv

if len(sys.argv) > 1:
    username = sys.argv[1]
else:
    username = '2223vbncjl5wstuee7lpictty'

# authorizes user
cid ="1af6192ff1eb4ab78a54e772f2956105" 
secret = "111bee776bc9497d8064d222a2a3ce93" 
client_credentials_manager = SpotifyClientCredentials(client_id=cid, client_secret=secret) 
sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager) 
sp.trace = True

# displays user info
user = sp.user(username)
#pprint.pprint(user)

# displays user's playlists
playlists = sp.user_playlists(username)
#for playlist in playlists['items']:
    #pprint.pprint(playlist['name'])
    #print(json.dumps(playlist['name']))

# displays playlist
uri = 'spotify:user:spotify:playlist:37i9dQZF1DXc7aGdJ1YSSD'
username = uri.split(':')[2]
playlist_id = uri.split(':')[4]
results = sp.user_playlist(username, playlist_id)
#print(json.dumps(results, indent=4))
songs = results["tracks"]["items"] 
ids = [] 
for i in range(len(songs)): 
    ids.append(songs[i]["track"]["id"]) 
features = sp.audio_features(ids) 
#df = pd.DataFrame(features)
totalData = []
colTitle = ['SongID','SongName','danceability','energy','key','loudness','mode','speechiness','acousticness','instrumentalness','liveness','valence','tempo']

for j in range(len(songs)):
    songData = []
    if j ==  0:
        totalData.append(colTitle)
    id = songs[j]["track"]["id"]
    songName = songs[j]["track"]["name"]
    songData.append(id)
    songData.append(songName)
    feature = sp.audio_features(id)
    songData.append(feature[0]['danceability'])
    songData.append(feature[0]['energy'])
    songData.append(feature[0]['key'])
    songData.append(feature[0]['loudness'])
    songData.append(feature[0]['mode'])
    songData.append(feature[0]['speechiness'])
    songData.append(feature[0]['acousticness'])
    songData.append(feature[0]['instrumentalness'])
    songData.append(feature[0]['liveness'])
    songData.append(feature[0]['valence'])
    songData.append(feature[0]['tempo'])
    totalData.append(songData)
#print(totalData)

csvPath = "SongData.csv"
#csv_writer(totalData, csvPath)

#def csv_writer(data, path):
#    # Write data to a CSV file path
with open(csvPath, "w", newline='') as csv_file:
    writer = csv.writer(csv_file, delimiter=',')
    for line in totalData:
        writer.writerow(line)

