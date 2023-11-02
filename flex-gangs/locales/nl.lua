local Translations = {
    error = {
        canceled = 'Gestopt..',
        zoneproblems = 'Aii, Chek snel je GPS..'
    },
    success = {
    },
    target = {
        takeflag = 'Pak vlag..',
    },
    progressbar = {
        placeflag = 'Vlag plaatsen..',
        removeflag = 'Vlag oppakken..',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
