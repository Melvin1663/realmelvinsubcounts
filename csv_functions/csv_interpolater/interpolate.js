module.exports = (x, y, z) => {
    let int = (z - x) / y;
    let arr = [];
    for (i = 1; i <= y; i++) {
        let out = (x + int * i);
        arr.push(out);
    }
    arr.unshift(x);
    arr[arr.length - 1] = z
    // console.log(arr)
    return arr;
};