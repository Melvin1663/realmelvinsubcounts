const { path, duplicates } = require('./config.json');

var colors = require('colors');
var fs = require('fs');
var src = require('script-tags');
var { resolve } = require('path')
var table = {
    names: []
}

for (let i = 1104537600000 / 86400000; i < Math.round(Date.now() / 86400000); i++) {
    table['"' + new Date(i * 86400000).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' }) + '"'] = []
}

let lastVal = 0;

try {
    var dir = fs.readdirSync(resolve(__dirname, './data')).filter(f => f.endsWith('.html'));
    dir.forEach((file, i) => {
        var data = fs.readFileSync(resolve(__dirname, `${path}${file}`), 'utf8');
        let txt = data.toString();

        let title = txt.match(/(?<=<title>).+?(?=<\/title>)/gm)[0].replace('\'s YouTube Stats (Summary Profile) - Social Blade Stats', '');

        let arr = src(txt);

        let filtered = arr.filter(v => v.attrs.type == 'text/javascript' && v.html.length > 1000)

        filtered = filtered[0].html

        // console.log(filtered)

        let log = filtered.split('\n').filter(a => a.includes('series: ['))

        // console.log(log)
        log = log[2];

        log = log.match(/(?<=data: ).+?(?= }])/gm)[0];

        log = JSON.parse(`{"data":${log}}`);
        log = log.data
        console.log(log)
        table.names[i] = title
        log.forEach(v => {
            if (!duplicates && lastVal == v[1]) { }
            else {
                let date = `${new Date(v[0]).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })}`
                console.log(date)
                table['"' + date + '"'][i] = v[1];
                lastVal = v[1];
            }
        })
        // log = log.map(v => `${new Date(v[0]).toLocaleDateString('en-US', { year: 'numeric', month: 'short' })} - ${colors.yellow(v[1].toLocaleString())}`)

        // console.log(log.join('\n'))
        // console.log('-'.repeat(20))
    })

    let csvData = [];
    // csvData.push(table.names);
    // let reverseCSV = [];
    for (const key in table) {
        let arr = [];
        arr.push(key);
        arr.push(...table[key])
        csvData.push(arr);
    }

    // reverseCSV = reverseCSV.reverse();

    // csvData.push(...reverseCSV)
    // csvData = csvData.slice(0, -1)


    // csvData = csvData.map(v => [`"${v[0]}"`, v[1]])
    // console.log(csvData)
    csvData = csvData.map(v => v.join(','))

    fs.writeFileSync(resolve(__dirname, './sheet.csv'), csvData.join('\n'))
} catch (e) {
    console.log('Error:', e.stack);
}