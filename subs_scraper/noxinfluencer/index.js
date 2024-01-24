const get = require('node-fetch2');
const fs = require('fs');
const options = require('./options.json');
const { resolve } = require('path');
const channelData = {
    names: [],
}

for (let i = 1104537600000 / 86400000; i < Math.round(Date.now() / 86400000) + 1; i++) {
    channelData[`"${new Date(i * 86400000).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })}"`] = []
}

fs.writeFileSync(resolve(__dirname, './sheet.csv'), '');

const fn = async () => {
    let i = 0;
    for await (c of options.channels) {
        let obj = await require('./script')(c);
        channelData.names[i] = obj.name;
        for (key in obj.data) {
            channelData[`"${key}"`][i] = obj.data[key];
        }
        i++;
    }

    let lastVal = []

    for (let v in channelData) {
        if (v == 'Names') continue;
        if (channelData[v]?.length) channelData[v].forEach((w, i) => {
            if (lastVal[i] == w) {
                if (i > -1) {
                    channelData[v][i] = undefined
                }
            } else lastVal[i] = w;
        })
    }
    let csvData = [];

    for (const k in channelData) {
        let arr = [];
        arr.push(k);
        arr.push(...channelData[k])
        csvData.push(arr);
    }

    csvData = csvData.map(v => v.join(','))

    fs.writeFileSync(resolve(__dirname, './sheet.csv'), csvData.join('\n'));
}

fn();