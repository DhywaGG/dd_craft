Core = {
    getjob = function()
        return QBX.PlayerData.job and QBX.PlayerData.job.name or nil
    end,

    getGangs = function()
        return QBX.PlayerData.gang and QBX.PlayerData.gang.name or nil
    end
}
