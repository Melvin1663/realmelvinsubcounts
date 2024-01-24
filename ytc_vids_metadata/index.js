const fs = require('fs');
const data = require('./data.json');

const res = {
    Index: ['Title', 'Views', 'Likes', 'Date', 'Comments']
};

const videos = fs.readFileSync('videos id.txt').toString().replaceAll('\r', '').split('\n')

for (i = 0; i < videos.length; i++) res[i] = [];


data.forEach((v, i) => {
    let oi = null;
    if (videos.includes(v.id)) oi = videos.indexOf(v.id)
    if (oi != null && res[oi]) res[oi].push(...['"' + v.snippet.title + '"', v.statistics.viewCount, v.statistics.likeCount, new Date(v.snippet.publishedAt).getTime(), v.statistics.commentCount])
})

let csvData = [];

for (const k in res) {
    let arr = [];
    arr.push(k);
    arr.push(...res[k])
    csvData.push(arr);
}

csvData = csvData.map(v => v.join(','))

fs.writeFileSync('sheet.csv', csvData.join('\n'))