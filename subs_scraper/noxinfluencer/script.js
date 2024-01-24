const get = require('node-fetch2');

module.exports = async (cid) => {
    let obj = {
        name: undefined,
        id: cid,
        data: {}
    };
    // let gap = 1641600000; // 19 days
    let gap = 1382400000; // 16 days
    let startDate = new Date('Jan 1, 2015');
    let joinedDateRegex = /"Joined "},{"text":"(.*?)"/gm;
    let channelNameRegex = /{"channelMetadataRenderer":{"title":"(?<=\")(.*?)(?=\")","description"/gm;
    let channelCreate = await get(`https://youtube.com/channel/${cid}/about`, { headers: { 'User-Agent': 'Mozilla/5.0' } }).catch(console.log).then(async r => await r.text());
    if (channelCreate) {
        let date = joinedDateRegex.exec(channelCreate);
        let cusername = channelNameRegex.exec(channelCreate);
        if (date.length) date = date[1];
        if (cusername.length) cusername = cusername[1];
        if (date) {
            if (new Date(date).getTime() > startDate.getTime()) startDate = new Date(date);
            obj.data[new Date(date).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })] = 0;
        }
        if (cusername) obj.name = cusername;
    }

    console.log(startDate);
    // let endDate = new Date('Sep 1, 2019').getTime();

    let retry = 0;
    let retryVerify = 0;
    let retryMax = 3;

    endDate = Date.now();
    // endDate = new Date('Feb 15, 2016').getTime();
    let verify = {};

    const verifyChannel = async () => {
        verify = await get(`https://www.noxinfluencer.com/youtube/channel/${cid}`, { headers: { 'User-Agent': 'Mozilla/5.0' } }).catch(e => {
            retryVerify++;
            if (retryVerify < retryMax) {
                console.log(`Retrying ${retryVerify}/${retryMax}`);
                verifyChannel();
            } else console.log(e)
        })
    }

    await verifyChannel();

    // verify.status = 200;

    if (verify?.status == 200) {
        // verify = await verify.text();
        if (/*verify.includes('Subs MileStone')*/ true) {
            for (i = startDate.getTime(); i <= endDate; i += gap) {
                console.log(`${/*require('./functions/date')(new Date(i)).replaceAll('-', '/')*/new Date(i).toLocaleDateString()} - ${cid} (${obj.name}) /${cid}/milestone?mileStoneDate=${require('./functions/date')(new Date(i))}&mileStone=0`)
                // let res = await get(`https://www.noxinfluencer.com/youtube/realtime-subs-count/${cid}/milestone?mileStoneDate=${require('./functions/date')(new Date('2016-1-31'))}&mileStone=0`);
                let res = await get(`https://www.noxinfluencer.com/youtube/realtime-subs-count/${cid}/milestone?mileStoneDate=${require('./functions/date')(new Date(i))}&mileStone=0`, { headers: { 'User-Agent': 'Mozilla/5.0' } }).catch(e => {
                    retry++;
                    if (retry < retryMax) {
                        console.log(`Retrying ${retry}/${retryMax}`);
                        i -= gap;
                    } else console.log(e)
                });
                retry = 0;
                if (res?.status == 200) {
                    res = await res.text();
                    if (!obj.name) obj.name = res.match(/<title>(.+)( Live.+)<\/title>/)[1];
                    let arr = res.match(/&quot;followerNumber&quot;:(\d+),&quot;time&quot;:(\d+)/gm)
                    if (arr.length) {
                        arr.slice(0, -1).forEach(e => {
                            let filtered = e.match(/&quot;followerNumber&quot;:(\d+),&quot;time&quot;:(\d+)/);
                            if (filtered.length) {
                                obj.data[new Date(parseInt(filtered[2])).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: '2-digit' })] = filtered[1];
                            }
                        })
                    }
                    console.log(true);
                } else console.log(false, res?.status, res?.statusText);
            }
        } else {
            console.log(`Skipped ${cid} Reason (No Milestone access)`);
        }
    } else {
        console.log(`Skipped ${cid} Reason (Status ${verify?.status}: ${verify?.statusText})`);
    }

    return obj;
}