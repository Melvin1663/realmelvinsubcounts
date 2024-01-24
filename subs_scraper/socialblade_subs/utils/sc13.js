const src = require('script-tags')

module.exports = (data, args) => {
    let res = {
        name: args[0],
        data: {}
    }

    let createdAt = data.match(/(?<=User Created<\/span><br\/><span style="font-weight: bold;">).+?(?=<\/span><\/div>)/gm);
    if (!createdAt?.length) {
        createdAt = data.match(/(?<=User Created<\/span><br \/><span style = "font-weight: bold;">).+?(?=<\/span><\/div>)/gm);
        if (!createdAt?.length) {
            createdAt = data.match(/(?<=User Created: ).+?(?=\  )/gm);
            if (!createdAt?.length) {
                createdAt = data.match(/(?<=User Created<\/div>\n	{5}<div class="stats-top-data-content">).+?(?=<\/div>)/gm);
                if (!createdAt?.length) {
                    createdAt = data.match(/(?<=User Created<\/div>\n<div class="stats-top-data-content">).+?(?=<\/div>)/gm);
                    if (!createdAt?.length) {
                        createdAt = data.match(/(?<=User Created<\/div>\n<div class="stats-top-data-content" style="font-size: 10pt;">).+?(?=<\/div>)/gm);
                        if (!createdAt?.length) {
                            createdAt = data.match(/(?<=User Created<\/span><br\/><span style="font-weight: bold;">).+?(?=<\/span>)/gm);
                            if (!createdAt?.length) console.log('No Created At Matches found')
                            else createdAt = createdAt[0];
                        } else createdAt = createdAt[0];
                    } else createdAt = createdAt[0];
                } else createdAt = createdAt[0];
            } else createdAt = createdAt[0];
        } else createdAt = createdAt[0];
    } else createdAt = createdAt[0];

    createdAt = new Date(createdAt.replace('th', '').replace('nd', '').replace('st', '')).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })

    res.data[createdAt] = 0

    let subs = src(data)
        .filter(a => a.attrs.type == 'text/javascript' && a.html.length > 500 && a.html.includes('TotalSubscribers'))[0].html
        .match(/(?<=Total Subs\\n" \+ ).+?(?=, {)/gm)[0]
        .replaceAll('\\n', '').split(' + ')
        .map(b => b.split(',').map(c => parseInt(c.replaceAll('-', '').replaceAll('"', ''))))

    subs.forEach(s => {
        s[0] = s[0].toString()
        let date = `${new Date(`${s[0].slice(4, -2)} ${s[0].slice(-2)}, ${s[0].slice(0, 4)}`).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })}`;
        res.data[date] = s[1];
    })

    return res;
}