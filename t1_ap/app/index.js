const express = require('express')
const crypto = require('crypto')
const path = require('path')
const fs = require('fs')
const bodyParser = require('body-parser')

const app = express()

app.use(bodyParser.urlencoded({ extended: true }))
app.use(express.json())

const config = {
	user: "admin",
	password: "four3l3phants"
}

let router = app

router.get('/', async (req, res) => {
	res.redirect('/login')
})

const verifyToken = (req, res, next) => {
	let s = `${config.user}:${config.password}`
	let valid = crypto.createHash('md5').update(s).digest('hex')
	let input = req.headers['x-token']

	console.log('token check')

	if (!input || input !== valid) {
		return res.sendStatus(400)
	}

	next()
}

router.get('/login', (req, res) => {
	res.sendFile(path.resolve(__dirname+'/views/login.html'))
})

router.post('/login', (req, res) => {

	console.log('post body:', req.body)

		try {
			let {user, password} = req.body
			console.log("body:", user, password)

			if (user != config.user) {
				return res.json({error: "invalid user"})
			}

			if (password != config.password) {
				return res.json({error: "invalid password"})
			}

			let token = crypto.createHash('md5').update(`${user}:${password}`).digest("hex")

			res.json({status: "ok", token})
		} catch(err) {
			res.sendStatus(300)
		}
})

router.get('/admin', (req, res) => {
	res.sendFile(path.resolve(__dirname+'/views/admin.html'))
})

router.get('/plist/:port', verifyToken, (req, res) => {
	let port = req.params.port || 3000

	require('portprocesses').listProcessesOnPort(port).then(result => {
		res.json(result)
	}).catch(err => {
	console.log('handled:', err)
		res.json({error: err.toString()})
	})
})

router.get('/pkill/:pid', verifyToken, (req, res) => {
	let pid = req.params.pid

	// sanity: make sure we dont try to kill this or parent pid
	if (!pid || parseInt(pid) === process.pid || parseInt(pid) == 1) {
		return res.json({error: 'plz dont kill me'})
	}

	try {
		var result = require('portprocesses').killProcess(pid)

		res.json({status: "ok", result})
	} catch(err) {
		res.json({error: err.toString()})
	}
})

module.exports = router

const PORT = 80 //3000

const server = app.listen(80, () => {
  console.log(`admin server listening @ http://localhost:80`)
})
