module.exports = (req, res, next) => {
    console.log("req.headers: ", req.headers);
    console.log("req.body: ", req.body);
    next()
  }