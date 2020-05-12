library(rtweet)

createTokenNoBrowser<- function(appName, consumerKey, consumerSecret, 
                                accessToken, accessTokenSecret) {
    app <- httr::oauth_app(appName, consumerKey, consumerSecret)
    params <- list(as_header = TRUE)
    credentials <- list(oauth_token = accessToken, 
                        oauth_token_secret = accessTokenSecret)
    token <- httr::Token1.0$new(endpoint = NULL, params = params, 
                                app = app, credentials = credentials)
    return(token)
}
