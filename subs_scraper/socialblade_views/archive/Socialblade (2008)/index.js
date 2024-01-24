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

let lastVal = 0;

try {
    var dir = fs.readdirSync(resolve(__dirname, './data')).filter(f => f.endsWith('.html'));
    dir.forEach((file, i) => {
        var data = fs.readFileSync(resolve(__dirname, `${path}${file}`), 'utf8');
        let txt = data.toString();
        let title = txt.match(/(?<=<title>).+?(?=<\/title>)/gm)[0].replace(' YouTube Stats by SocialBlade - Monthly Stats', '');

        let arr = src(txt);

        let filtered = arr.filter(v => v.attrs.type == 'text/javascript' && v.html.length > 1000 && v.html.includes('graphdivtotalsubs'))

        // console.log(filtered);

        filtered = filtered[0].html

        table.names[i] = title;

        filtered = filtered.match(/(?<=Subscribers\\n" \+\n).+?(?=\n +, {)/gm)[0];
        filtered = filtered.replaceAll('\\n', '').split(' +')
        filtered = filtered.map(v => v.split(', ').map(w => parseInt(w.replaceAll('"', ''))))
        // console.log(filtered);
        filtered.forEach(v => {
            if (!duplicates && lastVal == v[1]) { }
            else {
                //2012 04 28
                v[0] = v[0].toString()
                // console.log(`${v[0].slice(4, -2)} ${v[0].slice(-2)}, ${v[0].slice(0, 4)}`)
                let date = `${new Date(`${v[0].slice(4, -2)} ${v[0].slice(-2)}, ${v[0].slice(0, 4)}`).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })}`;
                // console.log(date)
                table['"' + date + '"'][i] = v[1]
                lastVal = v[1]
            }
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

        // csvData = csvData.map(v => [`"${v[0]}"`, v[1]])
        csvData = csvData.map(v => v.join(','))

        fs.writeFileSync(resolve(__dirname, './sheet.csv'), csvData.join('\n'))
    })
} catch (e) {
    console.log('Error:', e.stack);
}