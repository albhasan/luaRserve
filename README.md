# luaRserve

Execute R expressions from LUA through Rserve. <code>rclient.lua</code> is a Lua module that enables data sharing among the programming languages Lua and R through R's package Rserve. The client-server communication is handled through TCP using Lua's module <code>luasocket</code> and Rserve's <a href="http://rforge.net/Rserve/dev.html">QAP1 protocol</a>. 



<h3>Files:</h3>
<ul>
  <li><code>LICENSE</code> - License file.</li>
  <li><code>README.md</code> - This file.</li>
  <li><code>rclient.lua</code> - Rserve client for Lua.</li>
  <li><code>rsrv.lua</code> - Lua mapping of Rserve datatypes (rsrv.c).</li>
  <li><code>rtest.lua</code> - Tests of the <code>rclient</code> module. It requires a running Rserve (see below).</li>
</ul>



<h3>Prerequisites:</h3>
<ul>
  <li>Ubunbtu linux</li>
  <li>Internet access.</li>
  <li>Lua 5.1</li>
  <li><a href = "http://w3.impa.br/~diego/software/luasocket/">Lua socket</a> enables Lua to use the TCP and UDP communication protocols. It is used here specifically to handle communications between the Lua client and Rserve.</li>
  <li><a href = "https://github.com/ToxicFrog/vstruct">Lua vstruct</a> enables Lua to manipulate binary data. It used here to parse Rserve's binary data to Lua's datatypes.</li>
</ul>



<h3>Instructions Ubuntu:</h3>
<ol>
  <li>Start a terminal. Press <code>Ctr + Alt + T</code></li>
	<li>Install R. The instructions are <a href = https://cran.r-project.org/bin/linux/ubuntu/README.html>here</a></li>
  <li>Install Rserve:</li>
  <ol>
    <li>Start an R session in the terminal. Type <code>sudo R</code></li>
    <li>Install Rserve. Type <code>install.packages("Rserve")</code></li>
    <li>Exit R. Type <code>quit()</code></li>
  </ol>

  <li>Install Lua. Type <code>sudo apt-get install lua5.1 liblua5.1-dev</code></li>

  <li>Install luasocket:</li>
  <ol>
    <li><code>git clone https://github.com/diegonehab/luasocket.git</code></li>
    <li><code>cd luasocket</code></li>
    <li><code>make</code></li>
    <li><code>sudo make install</code></li>
    <li><code>lua test/hello.lua</code></li>
    <li><code>cd ..</code></li>
    <li><b>NOTE</b>: If luasocket compilation fails because of missing headers (e.g. lua.h),copy them to the common header folder. For example:
      <ol>
      <li><code>sudo ln -s /usr/include/lua5.1/lua.h /usr/include/lua.h</code></li>
      <li><code>sudo ln -s /usr/include/lua5.1/luaconf.h /usr/include/luaconf.h</code></li>
      <li><code>sudo ln -s /usr/include/lua5.1/lauxlib.h /usr/include/lauxlib.h</code></li>
    </ol>
    </li>
  </ol>

  <li>Install vstruct:</li>
  <ol>
    <li><code>git clone https://github.com/ToxicFrog/vstruct.git</code></li>
    <li><code>sudo cp -r vstruct /usr/local/share/lua/5.1/</code></li>
    <li><code>lua vstruct/test.lua</code></li>
  </ol>


  <li>Clone luaRserve:</li>
  <ol>
    <li><code>git clone https://github.com/albhasan/luaRserve.git</code></li>
  </ol>

  <li>Test luaRserve:</li>
  <ol>
    <li>Start Rserve. On a dfferent terminal type <code>R CMD Rserve</code>. To start in debug mode, start an <code>R</code> session, then load the package <code>library(Rserve)</code> and launch the server in debug mode <code>Rserve(debug=TRUE)</code>.</li>
    <li>Run the test: <code>cd luaRserve; lua rtest.lua</code>.</li>
  </ol>

  <h3>Notes:</h3>
  <ul>
    <li>This module has been tested on <code>Ubuntu-Linux 16.4</code> using <code>Lua 5.1.5</code>, <code>LuaSocket 3.0-rc1</code>, and <code>vstruct 2.0.0</code>.</li>
  </ul>
</ol>

