Config = {}

Config.Debug = true
Config.ShowZoneInRange = false -- Only show the zone on map when in range

Config.Flag = {
    item = 'gangflag',
    prop = 'prop_golfflag',
    removetool = 'wirecutter',
    removetime = 30, -- seconds
    placetime = 30, -- seconds
}

Config.AlarTime = 6 -- seconds
Config.BlipConfig = {
    unowned = {
        color = 40,
        opacity = 150
    },
    capturing = {
        color = 47
    },
    enemy = {
        color = 1,
        opacity = 150
    },
    owned = {
        color = 11,
        opacity = 150
    }
}

Config.GangZones = {
    [1] = {
        zone = {
            center = vector4(-179.09, -1544.71, 35.09, 51.51), -- Center of the zone
            boxsize = { -- Width and Height of the zone
                w = 50,
                h = 80
            },
        },
        houseloc = vector3(-185.35, -1551.27, 34.7), -- Location of the zonehouse
        housetier = 1, -- Which tier does it need to be
        stash = { -- Size of the stash
            size = 100000,
            slots = 50
        }
    }
}

Config.HousesType = {
    [1] = {
        shell = 'shell_warehouse1',
        moneywash = {
            [1] = {
                x = 100,
                y = 100,
                z = 100
            },
            [2] = {
                x = 100,
                y = 100,
                z = 100
            },
            [3] = {
                x = 100,
                y = 100,
                z = 100
            },
        },
        smelt = {
            [1] = {
                x = 100,
                y = 100,
                z = 100
            },
            [2] = {
                x = 100,
                y = 100,
                z = 100
            },
            [3] = {
                x = 100,
                y = 100,
                z = 100
            },
        },
        stash = {
            [1] = {
                x = 100,
                y = 100,
                z = 100
            },
            [2] = {
                x = 100,
                y = 100,
                z = 100
            },
            [3] = {
                x = 100,
                y = 100,
                z = 100
            },
        },
        computer = {
            x = 100,
            y = 100,
            z = 100
        },
    },
    [2] = {
        shell = 'shell_trailer',
        moneywash = {
            [1] = {
                x = 100,
                y = 100,
                z = 100
            },
            [2] = {
                x = 100,
                y = 100,
                z = 100
            },
            [3] = {
                x = 100,
                y = 100,
                z = 100
            },
        },
        smelt = {
            [1] = {
                x = 100,
                y = 100,
                z = 100
            },
            [2] = {
                x = 100,
                y = 100,
                z = 100
            },
            [3] = {
                x = 100,
                y = 100,
                z = 100
            },
        },
        stash = {
            [1] = {
                x = 100,
                y = 100,
                z = 100
            },
            [2] = {
                x = 100,
                y = 100,
                z = 100
            },
            [3] = {
                x = 100,
                y = 100,
                z = 100
            },
        },
        computer = {
            x = 100,
            y = 100,
            z = 100
        },
    },
    [3] = {
        shell = 'container_shell',
        moneywash = {
            [1] = {
                x = 100,
                y = 100,
                z = 100
            },
            [2] = {
                x = 100,
                y = 100,
                z = 100
            },
            [3] = {
                x = 100,
                y = 100,
                z = 100
            },
        },
        smelt = {
            [1] = {
                x = 100,
                y = 100,
                z = 100
            },
            [2] = {
                x = 100,
                y = 100,
                z = 100
            },
            [3] = {
                x = 100,
                y = 100,
                z = 100
            },
        },
        stash = {
            [1] = {
                x = 100,
                y = 100,
                z = 100
            },
            [2] = {
                x = 100,
                y = 100,
                z = 100
            },
            [3] = {
                x = 100,
                y = 100,
                z = 100
            },
        },
        computer = {
            x = 100,
            y = 100,
            z = 100
        },
    }
}

Config.DefaultLogo = 'default' -- If cant find logo take this
Config.GangLogos = {
    ['lostmc'] = 'default', -- GANGNAME = LOGONAME
}