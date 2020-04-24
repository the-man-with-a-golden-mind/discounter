const express =
      require("express");
const path = require("path");
const passport = require("passport");

const app = express();

const port = process.env.PORT || "8001";


const CLIENTID = "118954669613-n5nae0tff6do6puqdefccquqffn10ivo.apps.googleusercontent.com";
const CLIENTSECRET = "ElGiAboNx2VY4kfqjZPIABu0";

var GoogleStrategy = require('passport-google-oauth20').Strategy;
app.use(passport.initialize());
app.use(passport.session());

passport.serializeUser(function(user, done) {
    done(null, user);
});

passport.deserializeUser(function(user, done) {
    done(null, user);
});

passport.use(new GoogleStrategy({
    clientID: CLIENTID,
    clientSecret: CLIENTSECRET,
    callbackURL: "http://127.0.0.1:8001/auth/google/callback"
},
                                function(accessToken, refreshToken, profile, done) {
                                    return done(null, {name: profile.displayName, innerOauthID: profile.id});
                                }
                               ));

app.get("/", function(req, res) {
    res.send(JSON.stringify({st:"assad"}));
});

app.get('/auth/google',
        passport.authenticate('google', { scope: ['profile'] }));

app.get('/auth/google/callback', 
        passport.authenticate('google', { failureRedirect: '/login' }),
        function(req, res) {
            console.log(req.user);
            // Successful authentication, redirect home.
            // I don't need to put here res. I can return right json

            //res.redirect('/');
            res.send(JSON.stringify(req.user));
        });

const server = app.listen(port, function () {
    console.log("START");
});
