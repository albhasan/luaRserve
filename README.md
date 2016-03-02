# luaRserve

Execute R expressions from LUA through Rserve. <code>luarserve</code> is a Lua module that enables data sharing among the programming languages Lua and R through R's package Rserve. The client-server communication is handled through TCP using Lua's module luasocket. R's datatypes are mapped to Lua tables following the structure of Rserve's <a href="http://rforge.net/Rserve/dev.html">QAP1 protocol</a>.



<h3>Files:</h3>
<ul>
  <li><code>LICENSE</code> - License file.</li>
  <li><code>README.md</code> - This file.</li>
  <li><code>luarserve</code> - Lua module.</li>
  <li><code>rsrv.lua</code> - Lua mapping of Rserve datatypes (rsrv.c).</li>
  <li><code>test.lua</code> - Contains some examples of the intended use of the <code>luarserve</code> module.</li>
</ul>



<h3>Prerequisites:</h3>
<ul>
  <li>Ubunbtu linux 14.04. </li>
	<li>Internet access.</li>
  <li>Lua > 5.1</li>
  <li><a href = "http://w3.impa.br/~diego/software/luasocket/">Lua socket</a> enables Lua to use the TCP and UDP communication protocols. It is used here specifically to handle communications between the Lua client and Rserve.</li>
  <li><a href = "https://github.com/ToxicFrog/vstruct">Lua vstruct</a> enables Lua to manipulate binaru data. It used here specifically to parse Rserve's binary data to Lua's datatypes.</li>
</ul>



<h3>Instructions Ubuntu:</h3>
<ol>
  <li>Start a terminal. Press <code>Ctr + Alt + T</code></li>
	<li>Install R. The instructions are <a href = https://cran.r-project.org/bin/linux/ubuntu/README.html>here</a></li>
  <li>Install Rserve:</li>
  <ol>
    <li>Start an R session in the terminal. Type <code>sudo R</code></li>
    <li>Install Rserve. Type <code>install.packages("Rserve")</code></li>
    <li>Exit R. Type <code>quit</code></li>
  </ol>
  <li>Start Rserve. Type <code>R CMD Rserve</code>. To start in debug mode, , start an <code>R</code> session, then load the package <code>library(Rserve)</code> and then start the server in debug mode <code>Rserve(debug=TRUE)</code>.</li>
  <li>Install Lua. Type <code>sudo apt-get install lua5.2</code></li>
  <li>Install luasocket:</li>
  <ol>
    <li><code>git clone https://github.com/diegonehab/luasocket.git</code></li>
    <li><code>cd luasocket</code></li>
    <li><code>make</code></li>
    <li><code>sudo make install</code></li>
    <li><code>cd ..</code></li>
  </ol>
  <li>Set the environment variables. In the terminal type:</li>
  <ol>
    <li><code>export CDIR=/usr/local/lib/lua/5.2</code></li>
    <li><code>export LDIR=/usr/local/share/lua/5.2</code></li>
    <li><code>export LUA_PATH="$LDIR/?.lua;?.lua"</code></li>
    <li><code>export LUA_CPATH="$CDIR/?.so;?.so"</code></li>
  </ol>
  <li>Test luasocket</li>
  <ol>
    <li>Start a Lua session. Type <code>lua</code></li>
    <li>Load the module. Type <code>http = require("socket.http")</code></li>
    <li>Request a web page. Type <code>print(http.request("http://www.cs.princeton.edu/~diego/professional/luasocket"))</code></li>
    <li>The result must be HTML printed into the terminal</li>
    <li>Exit the Lua session. Type <code>os.exit()</code></li>
  </ol>


  <h3>Notes:</h3>
  <ul>
    <li>So far, this module just maps R's datyatypes to Lua' table. The client must handle further data transformation to other Lua structures (e.g matrixes or vectors).</li>
  </ul>


</ol>
