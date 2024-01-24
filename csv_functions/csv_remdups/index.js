const fs = require('fs');

let file = fs.readFileSync('data.csv');
let table = {
    names: []
}

for (let i = 1104537600000 / 86400000; i < Math.round(Date.now() / 86400000) + 1; i++) {
    table[`"${new Date(i * 86400000).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })}"`] = []
}

let memory = [];

if (file) {
    file = file.toString().replaceAll('\r', '').split('\n');
    table.names = file[0].split(',').slice(1);

    file.slice(1).forEach((e, i) => {
        row = e.split(',').slice(2)
        let match = e.match(/(.*")/gm);
        if (match) table[match[0]] = row
    })
}

for (let v in table) {
    if (v == 'names') continue;
    if (table[v]?.length) table[v].forEach((w, i) => {
        if (w == '' || w == 0) { }
        else if (memory[i] == w) {
            table[v][i] = undefined
        } else memory[i] = w;
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

fs.writeFileSync('sheet.csv', csvData.join('\n'))