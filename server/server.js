const express     = require('express');
const path        = require('path');
const queryString = require('query-string');
const request     = require('request');

const STATIC_PATH = path.join(__dirname, '..', 'dist');
const PORT        = 8080

const app = express();

app.use(express.json());
app.use(express.static(STATIC_PATH));

app.get('/*', (req, res) => {
  res.sendFile(path.join(STATIC_PATH, 'index.html'));
});

app.post('/search', (req, res) => {
  let apiURL = `https://itunes.apple.com/search?${queryString.stringify(req.body)}`;

  request(apiURL, (err, reponse, body) => {
    if (err) {
      res.json(err);
    }

    let results  = (JSON.parse(body)).results;
    let podcasts = results.map(podcast => (
      {
        title    : podcast.collectionName,
        link     : podcast.trackViewUrl,
        imageSrc : podcast.artworkUrl600
      }
    ))
    res.json(podcasts);
  });
});

app.listen(PORT, err => {
  if (! err) {
    console.log(`Server running on PORT:${PORT}`);
  }
});
