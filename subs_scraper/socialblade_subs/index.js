const config = require('./config.json');
const fs = require('fs');
const { resolve } = require('path');

let col = {}
let table = {
    Names: []
};
let dir = fs.readdirSync(resolve(__dirname, config.path))
let res;
let cmd = []

console.clear()
cmd.push('[?] Creating Date Values');
console.log(cmd.join('\n'))

for (let i = 1104537600000 / 86400000; i < Math.round(Date.now() / 86400000) + 1; i++) {
    table[`"${new Date(i * 86400000).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })}"`] = []
}

cmd[0] = cmd[0].replace('?', 'P')
cmd.push(`[?] Scanning File ${config.path}...`)
console.clear();
console.log(cmd.join('\n'))

dir.forEach((file, i) => {
    let data = fs.readFileSync(resolve(__dirname, `${config.path}${file}`), 'utf8');
    let args = file.replace('.html', '').split(' - ');

    if (i == 0) cmd[1] = cmd[1].replace('...', `${file.replace('html', '')}...`).replace('?', `${i + 1}/${dir.length}`);
    cmd[1] = cmd[1].replace(cmd[1].match(/(?<=.\/data\/).+(?=...)/gm)[0], file.replace('.html', '')).replace(`${i}/${dir.length}`, `${i + 1}/${dir.length}`)
    console.clear();
    console.log(cmd.join('\n'))

    switch (args[1]) {
        case '2013': {
            res = require('./utils/sc13')(data.toString(), args);

            if (!col[res.name]) col[res.name] = {};
            for (let j in res.data) {
                col[res.name][j] = res.data[j]
            }
        }; break;
        case '2008': {
            res = require('./utils/sc08')(data.toString(), args);

            if (!col[res.name]) col[res.name] = {};
            for (let j in res.data) {
                col[res.name][j] = res.data[j]
            }
        }; break;
        case '2019': {
            res = require('./utils/sc19')(data.toString(), args);

            if (!col[res.name]) col[res.name] = {};
            for (let j in res.data) {
                col[res.name][j] = res.data[j]
            }
        }; break;
    }
})

cmd[1] = cmd[1].replace(`${dir.length}/${dir.length}`, 'P');
cmd.push('[?] Compiling Results')
console.clear();
console.log(cmd.join('\n'));

let count = 0;
let lastVal = []

console.log(col);

for (let c in col) {
    table.Names[count] = c;
    for (let d in col[c]) {
        if (d != 'Invalid Date') table[`"${d}"`][count] = col[c][d]
    }

    count++;
}

cmd[2] = cmd[2].replace('?', 'P');
cmd.push('[?] Generating CSV Sheet');
console.clear();
console.log(cmd.join('\n'))

for (let v in table) {
    if (v == 'Names') continue;
    if (table[v]?.length) table[v].forEach((w, i) => {
        if (lastVal[i] == w) {
            if (i > -1) {
                table[v][i] = undefined
            }
        } else lastVal[i] = w;
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

cmd[3] = cmd[3].replace('?', 'P');
console.clear();
console.log(cmd.join('\n'))

fs.writeFileSync(resolve(__dirname, './sheet.csv'), csvData.join('\n'))