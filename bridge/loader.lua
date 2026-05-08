local framework

if GetResourceState('qbx_core') == 'started' then
    framework = 'qbx'
elseif GetResourceState('qb-core') == 'started' then
    framework = 'qb'
end

if not framework then
    print('[um-dispatch] ^1No supported framework detected (qb-core / qbx_core)^7')
    return
end

Bridge = require('bridge.' .. framework)
