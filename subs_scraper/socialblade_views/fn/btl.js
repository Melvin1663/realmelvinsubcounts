module.exports = (n) => {
    return n
        .replace('B', 'GB')
        .replace('M', 'MB')
        .replace('K', 'KB')
}