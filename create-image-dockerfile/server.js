const express = require('express')
const app = express()

// NOTES:
// Until Now, I assume that GET and POST must be imagine
// that it executes in client side or do by client.

app.get('/', function(req, res){
    res.send('<h1>Hello Bro!</h1>')
})

app.get('/contact', function(req, res){
    res.send('Contact me at: rohwid@gmail.com')
})

app.get('/about', function(req, res){
    res.send('My name is Rohman and I love sleep and code.')
})

app.listen(3000, function(){
    console.log('Server started on port 3000')
})