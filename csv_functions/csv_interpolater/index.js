const fs = require('fs');
const helper = require('./helper');
const table = {
    names: []
}

const inputs = {}

let file = fs.readFileSync('data.csv');

for (let i = 1104537600000 / 86400000; i < Math.round((Date.now() + 86400000) / 86400000) + 1; i++) {
    table[`"${new Date(i * 86400000).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })}"`] = []
}

if (file) {
    file = file.toString().replaceAll('\r', '').split('\n');
    table.names = file[0].split(',').slice(1);
    file[0].split(',').slice(1).forEach(n => inputs[n] = []);

    file.slice(1).forEach((e, r) => {
        row = e.split(',').slice(1);
        let lastVal = null;
        row.forEach((v, i) => {
            inputs[table.names[i]][r] = !v ? null : +v;
        })
    })

    table.names.forEach((n, t) => {
        // console.log(inputs[n].length)
        inputs[n][file.length-3] = +(inputs[n].filter(e => e).pop())

        let interpolated = helper(inputs[n]);
        let keys = Object.keys(table).slice(1);
        if (interpolated) {
            interpolated.forEach((v, i) => {
                // console.log(keys[i], i)
                table[keys[i]][t] = v;
            })
        }
    })
}

//console.log(table)

let csvData = [];

for (const k in table) {
    let arr = [];
    arr.push(k);
    arr.push(...table[k])
    csvData.push(arr);
}

csvData = csvData.map(v => v.join(','))

fs.writeFileSync('sheet.csv', csvData.join('\n'))