Enabling SSL on Apache on Windows

I spent a couple of hours the other night attempting to enable SSL on <a href="http://www.apache.org/" target="_blank">Apache</a> on my local dev machine and figured I'd share what I did in an effort to help the next poor soul who needs to do this.</p>
<p>Of course the first step was to Google <a href="http://www.google.com/search?q=enabling+ssl+on+apache+on+windows" target="_blank"><em>enabling ssl on apache on windows</em></a>, which yielded a bounty of resources.  The first link that I saw (and clicked) was to an article by <a href="http://www.neilstuff.com/" target="_blank">Neil C. Obremski</a> entitled <a href="http://www.neilstuff.com/apache/apache2-ssl-windows.htm" target="_blank"><em>Apache2 SSL on Windows</em></a>, and it gave me almost all of the info I needed.  One missing piece was that Neil's article is for Apache 2.0.x, but I'm running Apache 2.2.x.  Luckily, he includes a link to a <a href="http://www.neilstuff.com/apache/apache223ssl.doc" target="_blank">Word document written by Luke Holladay</a> which includes instructions for Apache 2.2.x.  To simplify things I've compiled the necessary  steps from both of those articles, and included some stuff that I had to figure out on my own. My step-by-step instructions follow.
<more/>
<h3>Step 1 - What You Need</h3>
<ul>
	<li>A copy of Apache that includes SSL support.</li>
	<li>A copy of OpenSSL.</li>
	<li>An openssl.cnf file.</li>
</ul>
<p>The copy of Apache that I had installed on my machine did not include SSL support, so I moseyed on down to the <a href="http://www.apache.org/dist/httpd/binaries/win32/" target="_blank">Apache download page</a>. You'll notice on that page that there are files named something like <em>apache_2.2.11-win32-x86-openssl-0.9.8i.msi</em>, as well as files named something like <em>apache_2.2.11-win32-x86-no_ssl.msi</em>.  You need to have the <em>openssl</em> version installed, not the <em>no_ssl</em> version (duh). I couldn't find any reliable info on manually adding SSL support to a no_ssl install, so I simply downloaded the most up-to-date version of the openssl installer and ran it.  It successfully upgraded my version of Apache without overwriting any of my existing config files.</p>
<p>The nice thing about that installer is that it includes a copy of OpenSSL, so you don't need to download that separately.</p>
<p>Finally, you need an openssl.cnf file, which doesn't come with the package.  I downloaded one that works from <a href="http://www.neilstuff.com/apache/openssl.cnf" target="_blank">Neil's site</a>.  If that link is broken you can find a copy attached to this blog post.  I have Apache installed in C:\Apache\, which means that I can find OpenSSL in C:\Apache\bin\, so I copied the openssl.cnf file into that directory.</p>
<h3>Step 2 - Create a Self-Signed Certificate</h3>
<p>This step will create a number of files related to your certificate.  Each of those files has the same name, with a different extension.  In the example commands below I've used the name <em>bob</em>.  Feel free to replace that with anything you like.</p>
<p>Open a command prompt and switch to the directory that contains OpenSSL (C:\Apache\bin\, in my case). To create a new certificate request type the following:
<code>openssl req -config openssl.cnf -new -out bob.csr -keyout bob.pem</code>
</p>
<p>You'll be prompted to answer a bunch of questions, the answers to which can all be left blank except for:
<ul>
	<li><em>PEM pass phrase</em>: This is the password associated with the private key (bob.pem) that you're generating. This will only be used in the next step, so make it anything you like, but don't forget it.</li>
	<li><em>Common Name</em>: This should be the fully-qualified domain name associated with this certificate. I was creating a certificate for a site on my local machine which I browsed to via http://savacms/, so I just entered <em>savacms</em>.  If I was creating a cert for my blog I would have entered <em>www.silverwareconsulting.com</em>.</li>
</ul>
</p>
<p>When the command completes you should have a two files called bob.csr and bob.pem in your folder.</p>
<p>Now we need to create a non-password protected key for Apache to use:
<code>openssl rsa -in bob.pem -out bob.key</code>
</p>
<p>You'll be prompted for the password that you created above, after which a file called bob.key should appear in your folder.</p>
<p>Finally, we need to create an X.509 certificate, which Apache also requires:
<code>openssl x509 -in bob.csr -out bob.cert -req -signkey bob.key -days 365</code>
</p>
<p>And that's it - you now have a self-signed certificate that Apache can use to enable SSL. I chose to move the required files from C:\Apache\bin\ to C:\Apache\conf\ssl\, but you can put them anywhere as you'll be pointing to them in your Apache config files.</p>
<h3>Step 3 - Enable SSL on Apache</h3>
<p>Open your httpd.conf file (which for me is in C:\Apache\conf\) and uncomment (remove the # sign) the following lines:
<ul>
	<li>#LoadModule ssl_module modules/mod_ssl.so</li>
	<li>#Include conf/extra/httpd-ssl.conf</li>
</ul>
</p>
<p>Open your httpd-ssl.conf file (which for me is in C:\Apache\conf\extra\) and update the section entitled <em>&lt;VirtualHost _default_:443&gt;</em>.  You'll need to update the values of <em>ServerAdmin</em>, <em>DocumentRoot</em>, <em>ServerName</em>, <em>ErrorLog</em> and <em>CustomLog</em> to match your environment.  You'll also need to point <em>SSLCertificateFile </em> to your .cert file and <em>SSLCertificateKeyFile</em> to your .key file.</p>
<p>Restart Apache and browse to https://localhost/.  You're now accessing your Apache server over SSL!</p>
<h3>Step 4 - Create a VirtualHost Entry for Your Site</h3>
<p>If you're like me, you're running Apache because you want to run multiple sites on your local machine.  In that case you undoubtedly have multiple &lt;VirtualHost&gt; entries in your httpd-vhosts.conf file.  In order to access a particular site via SSL, you need to add an additional &lt;VirtualHost&gt; entry for it.  To illustrate I'll show you an existing &lt;VirtualHost&gt; entry that I have, and then the new &lt;VirtualHost&gt; that I created to allow me to access that site via SSL.  Here's the original entry:
<code>
<VirtualHost *:80>
  ServerAdmin bob.silverberg@gmail.com
  DocumentRoot C:/wwwroot/savaCMS
  ServerName savaCMS
  DirectoryIndex index.html, index.cfm
  ErrorLog logs/savaCMS-error_log
  CustomLog logs/savaCMS-access_log common
<Directory C:/wwwroot/savaCMS>
Options All
AllowOverride All
</Directory>
</VirtualHost>
</code>
</p>
<p>And here's the additional entry that I added:
<code>
<VirtualHost *:443>
  SSLEngine on
  SSLCipherSuite ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL
  SSLCertificateFile "C:/Apache/conf/ssl/savacms.cert"
  SSLCertificateKeyFile "C:/Apache/conf/ssl/savacms.key"
  ServerAdmin bob.silverberg@gmail.com
  DocumentRoot C:/wwwroot/savaCMS
  ServerName savaCMS
  DirectoryIndex index.html, index.cfm
  ErrorLog logs/savaCMS-error_log
  CustomLog logs/savaCMS-access_log common
<Directory C:/wwwroot/savaCMS>
Options All
AllowOverride All
</Directory>
</VirtualHost>
</code>
</p>
<p>I can now browse to http://savaCMS/ as well as https://savaCMS/!  Hopefully these instructions will be found by the next person who chooses to attempt this.</p>
