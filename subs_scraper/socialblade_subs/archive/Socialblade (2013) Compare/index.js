const { path, duplicates } = require('./config.json');

var fs = require('fs');
var src = require('script-tags');
var { resolve } = require('path')
var table = {
    names: []
}

for (let i = 1104537600000 / 86400000; i < Math.round(Date.now() / 86400000); i++) {
    // console.log(new Date(i*86400000).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' }))
    table['"' + new Date(i * 86400000).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' }) + '"'] = []
}

let lastVal = [0, 0, 0];

try {
    var dir = fs.readdirSync(resolve(__dirname, './data')).filter(f => f.endsWith('.html'));
    dir.forEach((file, i) => {
        // console.log(i)
        var data = fs.readFileSync(resolve(__dirname, `${path}${file}`), 'utf8');
        let txt = data.toString();
        let title = txt.match(/(?<=<title>).+?(?=<\/title>)/gm)[0].match(/(?<=Compare ).+?(?= YouTube Statistics)/gm)[0];

        title = title.split(' and ');
        let tmp = title.slice(0, 1)[0]
        title = title.slice(1)
        title.unshift(...tmp.split(', '))
        title[1] = title[1].replaceAll(',', '')

        let arr = src(txt);

        let filtered = arr.filter(v => v.attrs.type == 'text/javascript' && v.html.length > 500 && v.html.includes('subscribersYTDYGraph'))

        // console.log(filtered);

        filtered = filtered[0].html

        title.forEach((t, j) => {
            table.names[i + j] = t;
        });
        // console.log(table.names[i])

        filtered = filtered.match(/(?<=\\n" \+ ).+?(?=, {)/gm)[0];
        filtered = filtered.trim()
        filtered = filtered.replaceAll('\\n', '').split(' + ')
        filtered = filtered.map(v => v.split(',').map(w => parseInt(w.replaceAll('-', '').replaceAll('"', ''))))
        // console.log(filtered)
        filtered.forEach(v => {
            //2012 04 28
            v[0] = v[0].toString()
            // console.log(`${v[0].slice(4, -2)} ${v[0].slice(-2)}, ${v[0].slice(0, 4)}`)
            let date = `${new Date(`${v[0].slice(4, -2)} ${v[0].slice(-2)}, ${v[0].slice(0, 4)}`).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })}`;
            v.forEach((w, k) => {
                if (duplicates == false && lastVal[k] == w) {} 
                else if (k != 0) {
                    // console.log(date)
                    table['"' + date + '"'][i + (k - 1)] = w
                    lastVal[k] = w
                }
            })
        })
    })
    // console.log(table)

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

    // console.log(table)
} catch (e) {
    console.log('Error:', e.stack);
}