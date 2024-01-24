const src = require('script-tags');

module.exports = (data, args) => {
    let res = {
        name: args[0],
        data: {}
    }

    let createdAt = data.match(/(?<=Member Since: ).+?(?=\nSubscriptions)/gm);
    if (!createdAt?.length) console.log('No Created At Matches found')
    else createdAt = new Date(createdAt[0]).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })

    res.data[createdAt] = 0;

    let views = src(data)
        .filter(a => a.attrs.type == 'text/javascript' && a.html.length > 1000 && a.html.includes('graphdivtotalviews'))[0].html
        .match(/(?<=Views\\n" \+\n).+?(?=\n +, {)/gm)[0]
        .replaceAll('\\n', '').split(' +')
        .map(v => v.split(',').map(w => parseInt(w.replaceAll('"', ''))))

    console.log(views)

    views.forEach(s => {
        s[0] = s[0].toString()
        let date = `${new Date(`${s[0].slice(4, -2)} ${s[0].slice(-2)}, ${s[0].slice(0, 4)}`).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })}`;
        res.data[date] = s[1];
    })

    return res;
}