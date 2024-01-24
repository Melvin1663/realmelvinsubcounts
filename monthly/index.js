const fs = require('fs');
const { resolve } = require('path');
const options = require('./options.json');

let arr = fs.readFileSync(resolve(__dirname, './data.txt'), { encoding: 'utf-8' }).toString().replaceAll('\r', '').split('\n').map(v => v ? +v : null);
let memory = 0;
let month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
let date = new Date(options.start);
let res = [];
let res_d = [];

arr.forEach(v => {
    if (date.getDate() != 1) memory += v;
    else {
        res_d.push(date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' }))
        res.push(memory);
        memory = 0;
    }
    date.setDate(date.getDate()+1)
})

console.log(res)

fs.writeFileSync(resolve(__dirname, './out.txt'), res.join('\n'));
fs.writeFileSync(resolve(__dirname, './out_d.txt'), res_d.join('\n'))


console.log('DONE')