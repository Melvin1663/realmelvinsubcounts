const fs = require('fs');
const { resolve } = require('path');

let file = fs.readFileSync('data.csv', { encoding: 'utf8' });
let table = {
    names: []
}

fs.writeFileSync(resolve(__dirname, './sheet.csv'), '');

for (let i = 1104537600000 / 86400000; i < Math.round(Date.now() / 86400000) + 1; i++) {
    table[`"${new Date(i * 86400000).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })}"`] = []
}

if (file) {
    file = file.replaceAll('\r', '').split('\n');
    let ornames = file[0].split(',').slice(1);
    let sortNames = [...ornames].sort();
    sortNames.forEach((n, i) => {
        let orindex = ornames.indexOf(n);
        // console.log(ornames)
        table.names[i] = n;
        if (orindex || orindex == 0) {
            file.slice(1).forEach(e => {
                // console.log(file.find(f => f.startsWith(e)).split(',').slice(2))
                // console.log(e, e.match(/(.*")/gm))
                let match = e.match(/(.*")/gm);
                if (match) table[match[0]][i] = file.find(f => f.startsWith(e)).split(',').slice(2)[orindex];
            })
        } else console.log(`No Original Index found for ${n} Index ${i}`);
        console.log(n, i, orindex)
    })
}

let csvData = [];

for (const k in table) {
    let arr = [];
    arr.push(k);
    arr.push(...table[k])
    csvData.push(arr);
}

csvData = csvData.map(v => v.join(','))

fs.writeFileSync(resolve(__dirname, './sheet.csv'), csvData.join('\n'));