const get = require('node-fetch2');
const ytci = require('@gonetone/get-youtube-id-by-url');
const data = require('./data.json');
const { resolve } = require('path');
const save = require('./save.js')

data.channels.forEach(async c => {
    let res = await get(c);
    if (!res || res.status >= 400) return;
    res = await res.text();
    let name = res.match(/"channelMetadataRenderer":{"title":"(.*?)(?=")"/gm)[0].replace(`"channelMetadataRenderer":{"title":"`, '').replace(/"/g, '');
    let url = res.match(/:88},{"url":"https:\/\/(.*?)(?=")"/gm)
    // console.log(url)
    if (url.length >= 2) url = url[url.length - 2].match(/"(.*?)(?=")"/gm);
    else url = url[url.length - 1].match(/"(.*?)(?=")"/gm);
    url = url[url.length - 1].replace(/"/g, '');
    url = url.replace(url.match(/=s\d+/gm)[0], '=');
    // console.log(url, c, name)
    console.log(name + ' - ' + c)
    save(url, resolve(__dirname, `./result/${name}.jpg`))
})