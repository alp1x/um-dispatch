return {
    -- Enables debug and send alerts when leo break the law.
    Debug = false,

    -- Dispatch notifications are sent containing only the alert name, omitting additional details. For more information, the dispatch menu can be accessed.
    ShortCalls = false,

    RespondKeybind = 'E',
    OpenDispatchMenu = 'O',

    -- Specify the duration for the alert to appear on the screen. The default time is 5 seconds for all alerts. To set a different duration for specific alerts, change the value in `alertTime = nil` found in the alerts.lua file.
    AlertTime = 8,

    -- maximum dispatch calls in dispatch list
    MaxCallList = 25,

    -- Set true if only on duty players can see the alert
    OnDutyOnly = true,

    -- Job Types or names that can access the dispatch menu. If you want to allow more jobs to see certain dispatch alerts. Go to alerts.lua and add the job name to the alert.
    Jobs = {
        "leo",
        "ems"
    },

    -- this would make the command work every 60 seconds to avoid spamming
    AlertCommandCooldown = 60,

    -- Delay between each default alert, prevent spamming
    DefaultAlertsDelay = 5,

    DefaultAlerts = {
        Speeding = false,
        Shooting = true,
        Autotheft = true,
        Melee = false,
        PlayerDowned = false,
        Explosion = false
    },

    MinOffset = 1,
    MaxOffset = 120,

    -- Set true if only can use 911/311 command when got a phone on inventory.
    PhoneRequired = true,
    PhoneItems = {
        "phone",
    },

}
