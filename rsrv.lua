-- ***********************************************************
-- LUA & RSERVER
-- Variables used to communicate LUA and RSERVE
-- This is  interpretation of Rsrv.h -- https://github.com/s-u/Rserve
-- ***********************************************************
local rsrv = {}


QAP1_DATATYPES = {}
QAP1_DATATYPES[1] = "DT_INT"        -- int -- (4 bytes) integer
QAP1_DATATYPES[2] = "DT_CHAR"       -- char
QAP1_DATATYPES[3] = "DT_DOUBLE"     -- double
QAP1_DATATYPES[4] = "DT_STRING"     -- 0 terminted string -- (n bytes) null terminated string
QAP1_DATATYPES[5] = "DT_BYTESTREAM" -- stream of bytes (unlike DT_STRING may contain 0) -- (n bytes) any binary data
QAP1_DATATYPES[10] = "DT_SEXP"      -- encoded SEXP -- R's encoded SEXP
QAP1_DATATYPES[11] = "DT_ARRAY"     -- array of objects (i.e. first 4 bytes specify how many subsequent objects are part of the array; 0 is legitimate)
QAP1_DATATYPES[32] = "DT_CUSTOM"    -- custom types not defined in the protocol but used by applications
QAP1_DATATYPES[64] = "DT_LARGE"     -- new in 0102: if this flag is set then the length of the object is coded as 56-bit integer enlarging the header by 4 bytes



QAP1_COMMANDS = {}
QAP1_COMMANDS[0x001] = "CMD_login"      -- "name\npwd" : -
QAP1_COMMANDS[0x002] = "CMD_voidEval"   --  string : -
QAP1_COMMANDS[0x003] = "CMD_eval"       -- string | encoded SEXP : encoded SEXP
QAP1_COMMANDS[0x004] = "CMD_shutdown"   -- [admin-pwd] : -
-- security/encryption - all since 1.7-0
QAP1_COMMANDS[0x005] = "CMD_switch"     -- string (protocol)  : -
QAP1_COMMANDS[0x006] = "CMD_keyReq"     -- string (request) : bytestream (key)
QAP1_COMMANDS[0x007] = "CMD_secLogin"   -- bytestream (encrypted auth) : -
QAP1_COMMANDS[0x00f] = "CMD_OCcall"    -- SEXP : SEXP  -- it is the only command
								                    --    supported in object-capability mode
                                    --    and it requires that the SEXP is a
                                    --    language construct with OC reference
                                    --    in the first position
QAP1_COMMANDS[0x434f7352] = "CMD_OCinit"      -- SEXP -- 'RsOC' - command sent from
                                              --    the server in OC mode with the packet
                                              --    of initial capabilities.
QAP1_COMMANDS[0x010] = "CMD_openFile"    -- fn : -
QAP1_COMMANDS[0x011] = "CMD_createFile"  -- fn : -
QAP1_COMMANDS[0x012] = "CMD_closeFile"   -- - : -
QAP1_COMMANDS[0x013] = "CMD_readFile"    -- [int size] : data... ; if size not present,
                                      --    server is free to choose any value - usually
                                      --    it uses the size of its static buffer */
QAP1_COMMANDS[0x014] = "CMD_writeFile"   -- data : -
QAP1_COMMANDS[0x015] = "CMD_removeFile"  -- fn : -
-- object manipulation
QAP1_COMMANDS[0x020] = "CMD_setSEXP"     -- string(name), REXP : -
QAP1_COMMANDS[0x021] = "CMD_assignSEXP"  -- string(name), REXP : - ; same as setSEXP except that the name is parsed
-- session management (since 0.4-0)
QAP1_COMMANDS[0x030] = "CMD_detachSession"     -- : session key
QAP1_COMMANDS[0x031] = "CMD_detachedVoidEval"  -- string : session key; doesn't
QAP1_COMMANDS[0x032] = "CMD_attachSession"     -- session key : -
-- control commands (since 0.6-0) - passed on to the master process
-- Note: currently all control commands are asychronous, i.e. RESP_OK
--   indicates that the command was enqueued in the master pipe, but there
--   is no guarantee that it will be processed. Moreover non-forked
--   connections (e.g. the default debug setup) don't process any
--   control commands until the current client connection is closed so
--   the connection issuing the control command will never see its
--   result.
QAP1_COMMANDS[0x40] = "CMD_ctrl"              -- -- not a command - just a constant --
QAP1_COMMANDS[0x42] = "CMD_ctrlEval"          -- string : -
QAP1_COMMANDS[0x45] = "CMD_ctrlSource"        -- string : -
QAP1_COMMANDS[0x44] = "CMD_ctrlShutdown"      -- - : -
-- 'internal' commands (since 0.1-9)
QAP1_COMMANDS[0x081] = "CMD_setBufferSize"    -- [int sendBufSize]
                                            --    this commad allow clients to request
                                            --    bigger buffer sizes if large data is to be
                                            --    transported from Rserve to the client.
                                            --    (incoming buffer is resized automatically)
QAP1_COMMANDS[0x082] = "CMD_setEncoding"      -- string (one of "native","latin1","utf8") : -; since 0.5-3
-- special commands - the payload of packages with this mask does not contain defined parameters
QAP1_COMMANDS[0xf0] = "CMD_SPECIAL_MASK"
QAP1_COMMANDS[0xf5] = "CMD_serEval"          -- serialized eval - the packets are raw serialized data without data header
QAP1_COMMANDS[0xf6] = "CMD_serAssign"        -- serialized assign - serialized list with [[1]]=name, [[2]]=value
QAP1_COMMANDS[0xf7] = "CMD_serEEval"         -- serialized expression eval - like serEval with one additional evaluation round



QAP1_XPRESSIONTYPES = {}
QAP1_XPRESSIONTYPES[0] = "XT_NULL"      -- P  data: [0]
QAP1_XPRESSIONTYPES[1] = "XT_INT"       -- -  data: [4]int
QAP1_XPRESSIONTYPES[2] = "XT_DOUBLE"    -- -  data: [8]double
QAP1_XPRESSIONTYPES[3] = "XT_STR"       -- P  data: [n]char null-term. strg
QAP1_XPRESSIONTYPES[4] = "XT_LANG"      -- -  data: same as XT_LIST
QAP1_XPRESSIONTYPES[5] = "XT_SYM"       -- -  data: [n]char symbol name
QAP1_XPRESSIONTYPES[6] = "XT_BOOL"      -- -  data: [1]byte boolean (1=TRUE, 0=FALSE, 2=NA)
QAP1_XPRESSIONTYPES[7] = "XT_S4"        -- P  data: [0]
QAP1_XPRESSIONTYPES[16] = "XT_VECTOR"   -- P  data: [?]REXP,REXP,..
QAP1_XPRESSIONTYPES[17] = "XT_LIST"     -- -  X head, X vals, X tag (since 0.1-5)
QAP1_XPRESSIONTYPES[18] = "XT_CLOS"     -- P  X formals, X body  (closure; since 0.1-5)
QAP1_XPRESSIONTYPES[19] = "XT_SYMNAME"  -- s  same as XT_STR (since 0.5)
QAP1_XPRESSIONTYPES[20] = "XT_LIST_NOTAG"       -- s  same as XT_VECTOR (since 0.5)
QAP1_XPRESSIONTYPES[21] = "XT_LIST_TAG"         -- P  X tag, X val, Y tag, Y val, ... (since 0.5)
QAP1_XPRESSIONTYPES[22] = "XT_LANG_NOTAG"       -- s  same as XT_LIST_NOTAG (since 0.5)
QAP1_XPRESSIONTYPES[23] = "XT_LANG_TAG"         -- s  same as XT_LIST_TAG (since 0.5)
QAP1_XPRESSIONTYPES[26] = "XT_VECTOR_EXP"       -- s  same as XT_VECTOR (since 0.5)
QAP1_XPRESSIONTYPES[27] = "XT_VECTOR_STR"       -- -  same as XT_VECTOR (since 0.5 but unused, use XT_ARRAY_STR instead)
QAP1_XPRESSIONTYPES[32] = "XT_ARRAY_INT"        -- P  data: [n*4]int,int,..
QAP1_XPRESSIONTYPES[33] = "XT_ARRAY_DOUBLE"     -- P  data: [n*8]double,double,..
QAP1_XPRESSIONTYPES[34] = "XT_ARRAY_STR"        -- P  data: string,string,.. (string=byte,byte,...,0) padded with '\01'
QAP1_XPRESSIONTYPES[35] = "XT_ARRAY_BOOL_UA"    -- -  data: [n]byte,byte,..  (unaligned! NOT supported anymore)
QAP1_XPRESSIONTYPES[36] = "XT_ARRAY_BOOL"       -- P  data: int(n),byte,byte,...
QAP1_XPRESSIONTYPES[37] = "XT_RAW"              -- P  data: int(n),byte,byte,...
QAP1_XPRESSIONTYPES[38] = "XT_ARRAY_CPLX"       -- P  data: [n*16]double,double,... (Re,Im,Re,Im,...)
QAP1_XPRESSIONTYPES[48] = "XT_UNKNOWN"          -- P  data: [4]int - SEXP type (as from TYPEOF(x)) */
                    --                             |
                    --                               +--- interesting flags for client implementations:
                    --                                    P = primary type
                    --                                    s = secondary type - its decoding is identical to
                    --									    a primary type and thus the client doesn't need to
                    --										decode it separately.
                    --									- = deprecated/removed. if a client doesn't need to
                    --									    support old Rserve versions, those can be safely
                    --										skipped.
                    --  Total primary: 4 trivial types (NULL, STR, S4, UNKNOWN) + 6 array types + 3 recursive types
QAP1_XPRESSIONTYPES[64] = "XT_LARGE"      -- new in 0102: if this flag is set then the length of the object
                                          --    is coded as 56-bit integer enlarging the header by 4 bytes
QAP1_XPRESSIONTYPES[128] = "XT_HAS_ATTR"  -- flag; if set, the following REXP is the attribute



QAP1_BOOL = {}
QAP1_BOOL[0] = "BOOL_FALSE"
QAP1_BOOL[1] = "BOOL_TRUE"
QAP1_BOOL[2] = "BOOL_NA"



QAP1_RESP = {}
QAP1_RESP[0x10000] = "0x10000"      -- all responses have this flag set
QAP1_RESP[0x0001] = "RESP_OK"       -- command succeeded; returned parameters depend on the command issued
QAP1_RESP[0x0002] = "RESP_ERR"      -- command failed, check stats code attached string may describe the error



QAP1_ERR = {}
QAP1_ERR[0x41] = "ERR_auth_failed"      -- auth.failed or auth.requested but no login came. in case of authentification failure due to name/pwd mismatch, server may send CMD_accessDenied instead
QAP1_ERR[0x42] = "ERR_conn_broken"      -- connection closed or broken packet killed it
QAP1_ERR[0x43] = "ERR_inv_cmd"          -- unsupported/invalid command
QAP1_ERR[0x44] = "ERR_inv_par"          -- some parameters are invalid
QAP1_ERR[0x45] = "ERR_Rerror"           -- R-error occured, usually followed by connection shutdown
QAP1_ERR[0x46] = "ERR_IOerror"          -- I/O error
QAP1_ERR[0x47] = "ERR_notOpen"          -- attempt to perform fileRead/Write on closed file
QAP1_ERR[0x48] = "ERR_accessDenied"     -- this answer is also valid on CMD_login; otherwise it's sent if the server deosn;t allow the user to issue the specified command. (e.g. some server admins may block file I/O operations for some users)
QAP1_ERR[0x49] = "ERR_unsupportedCmd"   -- unsupported command
QAP1_ERR[0x4a] = "ERR_unknownCmd"       -- unknown command - the difference between unsupported and unknown is that unsupported commands are known to the server but for some reasons (e.g. platform dependent) it's not supported. unknown commands are simply not recognized by the server at all.
-- The following ERR_.. exist since 1.23/0.1-6
QAP1_ERR[0x4a] = "ERR_data_overflow"    -- incoming packet is too big. currently there is a limit as of the size of an incoming packet
QAP1_ERR[0x4c] = "ERR_object_too_big"   -- the requested object is too big to be transported in that way. If received after CMD_eval then the evaluation itself was successful. optional parameter is the size of the object
QAP1_ERR[0x4d] = "ERR_out_of_mem"       -- out of memory. the connection is usually closed after this error was sent
QAP1_ERR[0x4e] = "ERR_ctrl_closed"      -- control pipe to the master process is closed or broken
QAP1_ERR[0x50] = "ERR_session_busy"     -- session is still busy
QAP1_ERR[0x51] = "ERR_detach_failed"    -- unable to detach seesion (cannot determine peer IP or problems creating a listening socket for resume)
QAP1_ERR[0x61] = "ERR_disabled"         -- feature is disabled
QAP1_ERR[0x62] = "ERR_unavailable"      -- feature is not present in this build
QAP1_ERR[0x63] = "ERR_cryptError"       -- crypto-system error
QAP1_ERR[0x64] = "ERR_securityClose"    -- erver-initiated close due to security violation (too many attempts, excessive timeout etc.)


return rsrv
