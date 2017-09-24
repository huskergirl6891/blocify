== README

Blocify predicts if you will like a certain song using Amazon Web Services Machine Learning (AWS ML) and Spotify song data.
Here's how this application works:

1.  Create a model

A machine learning model is really just an equation that takes in certain information and spits out a prediction.  The simplest type of model is called binary classification, which basically means it will give one of two answers.  Think "yes" or "no".  To use a model, the first step is to train it.  One way of doing this is to show the model a large data set that already has the correct answers.  This is called supervised training.  All of that information is used to generate an equation that can then be used to make predictions on new data.  AWS has a service called Machine Learning that makes this whole process very straightforward.  After uploading the training data set, AWS takes care of the rest.  In Blocify, a model has already been created using song information from Spotify, as well as known ratings of whether the song was liked or not.

2.  Create an endpoint

AWS requires an endpoint to communicate to/from this application.  To minimize cost and to ensure the endpoint is only turned on when needed, endpoints must be created and deleted manually.  It usually takes a few minutes for the endpoint to be created.

3.  Generate a new prediction

Enter a song name.  The application will send a request to Spotify to search for the song.  If found, Spotify will return information about the song, such as "danceability", "key", and "tempo".

4.  See the results

The song information is then sent to AWS.  The model analyzes the song information, and generates a prediction of whether the new song will be liked or not.
