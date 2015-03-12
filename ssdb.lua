 -- Lua client for https://github.com/ideawu/ssdb
 -- Copyright (c) 2015 Eleme, Inc.

local spp = require 'spp_lua'

local conversions = {
    number = function(t)
        return tonumber(t[0])
    end,

    string = function(t)
        return t[0]
    end,

    boolean = function(t)
        return tonumber(t[0]) ~= 0
    end,

    table = function(t)
        return t
    end
}

local commands = {
    set             = 'number',
    setx            = 'number',
    expire          = 'number',
    ttl             = 'number',
    setnx           = 'number',
    get             = 'number',
    getset          = 'string',
    del             = 'number',
    incr            = 'number',
    exists          = 'boolean',
    getbit          = 'number',
    setbit          = 'number',
    countbit        = 'number',
    substr          = 'string',
    strlen          = 'number',
    keys            = 'table',
    scan            = 'table',
    rscan           = 'table',
    multi_set       = 'number',
    multi_get       = 'table',
    multi_del       = 'number',
    hset            = 'number',
    hget            = 'string',
    hdel            = 'number',
    hincr           = 'number',
    hexists         = 'boolean',
    hsize           = 'number',
    hlist           = 'table',
    hrlist          = 'table',
    hkeys           = 'table',
    hgetall         = 'table',
    hscan           = 'table',
    hrscan          = 'table',
    hclear          = 'number',
    multi_hset      = 'number',
    multi_hget      = 'table',
    multi_hdel      = 'number',
    zset            = 'number',
    zget            = 'number',
    zdel            = 'number',
    zincr           = 'number',
    zexists         = 'boolean',
    zsize           = 'number',
    zlist           = 'table',
    zrlist          = 'table',
    zkeys           = 'table',
    zscan           = 'table',
    zrscan          = 'table',
    zrank           = 'number',
    zrrank          = 'number',
    zrange          = 'table',
    zrrange         = 'table',
    zclear          = 'number',
    zcount          = 'number',
    zsum            = 'number',
    zavg            = 'number',
    zremrangebyrank = 'number',
    zremrangebyscore= 'number',
    multi_zset      = 'number',
    multi_zget      = 'table',
    multi_zdel      = 'number',
    qsize           = 'number',
    qclear          = 'number',
    qfront          = 'string',
    qback           = 'string',
    qget            = 'string',
    qslice          = 'table',
    qpush           = 'string',
    qpush_front     = 'number',
    qpush_back      = 'number',
    qpop            = 'string',
    qpop_front      = 'string',
    qpop_back       = 'string',
    qlist           = 'table',
    qrlist          = 'table',
    dbsize          = 'number',
    info            = 'table',
    auth            = 'boolean'
}

local Connection = {}
Connection.__index = Connection

function Connection:new(options)
    local self = setmetatable({}, Connection)
    self.port = options.port or 8888
    self.host = options.host or '127.0.0.1'
    self.auth = options.auth
    self.timeout = options.time or 0

    self.sock = nil
    self.commands = {}
    self.parser = spp:new()
    return self
end

function Connection:connect(self)
    local err

    self.sock, err = ngx.sock.tcp()

    if err and not sock then
        return sock, err
    end

    self.sock:settimeout(self.timeout)
    self.sock:setkeepalive(true)
    return self.sock:connect(self.host, self.port)  -- ok, err
end

function Connection:close(self)
    local sock = self.sock
    self.parser:clear()
    self.sock = nil
    return sock:close()
end

function Connection:encode(self, args)
    --
end
