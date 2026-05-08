local codes = require 'shared.codes'

lib.addCommand('code', {
    help = 'Send a code to the dispatch',
    params = { {
        name = 'codenumber',
        type = 'number',
        help = 'Code number (0, 1, 2, 3, 4, 77, 99)'
    }
    },
}, function(source, args)
    local plyJob = Bridge.GetPlayerJob(source)
    if not plyJob then return end

    if plyJob.type ~= 'leo' then
        return
    end

    local codeNumber = args.codenumber
    if not codeNumber then return end

    local code = codes[tostring(codeNumber)]
    if not code then return end

    TriggerClientEvent('ps-dispatch:client:sendCode', source, code)
end)
