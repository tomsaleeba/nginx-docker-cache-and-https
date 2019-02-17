const express = require('express')
const app = express()
const port = 3000

const signals = ['SIGINT', 'SIGHUP', 'SIGTERM']
signals.forEach(sig => {
  process.on(sig, function () {
    console.log(`Caught '${sig}' signal, exiting`)
    process.exit()
  })
})

app.get('/nocache', (req, res) => {
  console.log(`${new Date()} hit /nocache`)
  setTimeout(() => {
    const d = new Date()
    console.log(`${d} resp /nocache`)
    res.set('Cache-Control', 'no-cache, private').send(`${d} Hello World!`)
  }, 2000)
})

app.get('/cache', (req, res) => {
  console.log(`${new Date()} hit /cache`)
  setTimeout(() => {
    const d = new Date()
    console.log(`${d} resp /cache`)
    res.send(`${d} Hello World!`)
  }, 2000)
})

app.get('/api', (req, res) => {
  console.log(`${new Date()} hit /api`)
  setTimeout(() => {
    const d = new Date()
    console.log(`${d} resp /api`)
    res.send(`${d} Hello API!`)
  }, 2000)
})

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
