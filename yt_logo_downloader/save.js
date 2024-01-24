const fs = require('fs');
const client = require('https');

function downloadImage(url, filepath) {
    client.get(url, (res) => {
        res.pipe(fs.createWriteStream(filepath));
    });
}

module.exports = downloadImage;