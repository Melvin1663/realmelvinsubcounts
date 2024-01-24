const fs = require('fs');

let file = fs.readFileSync('data.csv');
let table = {
    names: []
}

let months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

let memory = [];

if (file) {
    file = file.toString().replaceAll('\r', '').split('\n');
    table.names = file[0].split(',').slice(1);

    for (let i = 1104537600000 / 86400000; i < Math.round(Date.now() / 86400000) + 1; i++) {
        let date = new Date(i * 86400000)
        table[`${date.getDate()}-${months[date.getMonth()]}-${date.getFullYear().toString().slice(2)}`] = new Array(table.names.length)
    }

    file.slice(1).forEach((e, i) => {
        row = e.split(',').slice(1)
        // let match = e.match(/(.*")/gm);
        /* if (match) */ table[/*match[0]*/e.split(',')[0]] = row
    })
}

for (let v in table) {
    if (v == 'names') continue;
    if (table[v]?.length) table[v].forEach((w, i) => {
        if (w == 0) { }
        else if (w == '') table[v][i] = undefined

        if (memory[i] == w) {
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

fs.writeFileSync('deduplicated.csv', csvData.join('\n'))