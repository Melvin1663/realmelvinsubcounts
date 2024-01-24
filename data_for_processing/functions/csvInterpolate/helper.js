const fs = require('fs');
const interpolate = require('./interpolate');

module.exports = (arr) => {
    let res = [];
    let gaps = [];

    let isEmpty = false;
    let hasData = false;
    let memory = 0

    arr.forEach((x, i) => {
        // if (x === null && isEmpty == true) res.push('\n')
        if (hasData == false) res.push('')
        if (x == 0 || x) {
            gaps.push(arr.slice(memory, i + 1))
            isEmpty = false;
            hasData = true;
            memory = 0;
        }
        if (x == 0 || x && isEmpty == false) { memory = i; };
        if (!x && x != 0 && isEmpty == false) { isEmpty = true; memory = i - 1; }
    })

    gaps = gaps.splice(1)

    gaps.forEach((gap, i) => {
        if (gap.length == 2) {
            i == 0 ? null : gap = gap.splice(1);
            return res.push(...gap);
        };

        let interpolated = interpolate(gap[0], gap.length - 1, gap[gap.length - 1]);

        i == 0 ? null : interpolated = interpolated.splice(1);

        res.push(...interpolated);
    });

    return res;
}