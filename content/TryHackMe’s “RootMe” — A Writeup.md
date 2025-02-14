---
tags:
  - security
---
Today, I did [“RootMe” on TryHackMe](https://tryhackme.com/room/rrootme). This was a fun box. It was short and sweet - educational, but still fun.  
Let’s get into it:

# First Steps

Let’s start off with a nmap. Well, we have to, it’s part of the task.

![](https://miro.medium.com/v2/resize:fit:700/1*-KI083Zrc1IYVKMxly1hJQ.png)

Once nmap is finished, we see the open ports, along with the Apache version, and SSH on port 22.

![](https://miro.medium.com/v2/resize:fit:700/1*Pl6Fx9K77MneAUUaMkL3zw.png)

nmap

After browsing to the site and seeing a static page, we can use our big brains and run a gobuster in dir mode. Or, we can read the next task, and figure it out that way. But pretending you thought of it all on your own is way better.

![](https://miro.medium.com/v2/resize:fit:700/1*cm44mwY8w3aJSnNz1WO2UA.png)

gobuster dir command

If you’re confused, I’ll break down this command.

`1: gobuster dir`

Tells gobuster to run in dir mode, meaning it will find directories.  
For example, 10.10.87.237/dir/.

`2: -u 10.10.87.237`

Obviously, this is just telling gobuster the IP. The `u` is for `url`.

`3: -w /usr/share/wordlists/{snip}`

This is just telling gobuster what wordlist to use. In this example, I’m using raft-small-words.txt, which is part of [SecLists](https://github.com/danielmiessler/SecLists) by Daniel Miessler.

`4: -o gobuster.out`

This puts the resulting gobuster scan into a file called gobuster.out, which you can then reference later with `cat gobuster.out` or `nano gobuster.out` or whatever other command you want to use.

Anyway, once that’s done, we see a couple of directories:

![](https://miro.medium.com/v2/resize:fit:700/1*Fcq-HNfrDn7i978uSRljmw.png)

gobuster.out

Panel? Weird. Let’s go there!

![](https://miro.medium.com/v2/resize:fit:700/1*FArNkBpliX7f9SinuuMvEQ.png)

/panel

Oooh, baby. Break out the red panties.

# The Fun Part

First, let’s get our webshell, and change the variables inside to match our IP and port we’re gonna listen on:

![](https://miro.medium.com/v2/resize:fit:700/1*7qXVJVsJunn0N9cpllzqjg.png)

![](https://miro.medium.com/v2/resize:fit:323/1*HjiNqLSWSSfkEHG29jAJRw.png)

How do I know that we can upload a webshell here, you might be asking?  
Well, the task says: _‘find a form to upload and get a reverse shell, and find the flag.’_

So, you know, just assuming.

Anyway, let’s upload!

![](https://miro.medium.com/v2/resize:fit:700/1*m0I5cDFBPZQyM8msoVnBzQ.png)

Oh. Damn.  
I’m no polyglot, but I think I know what that error is.

So, let’s get to spoofin’.

First, I change the filename to shell.jpg.php, and... nada.

How about shell.php5?

![](https://miro.medium.com/v2/resize:fit:690/1*ef_K2dotnbYbbiyc5eNWYw.png)

Wow. That was easy.

Run `nc -lnvp 9001` before we visit the shell.php5 page and hooray!

![](https://miro.medium.com/v2/resize:fit:700/1*mAyPxC0hzu9adca6qoHClA.png)

Connected!

So, we have our shell now! Some people might go about upgrading it, with their `python -c 'import pty;pty.spawn("/bin/bash")'`and their stty -raw whatever. Not me. Mama raised a masochist.

Let’s have a little snoop around. First, let’s get user.txt, considering that’s our next task.

![](https://miro.medium.com/v2/resize:fit:164/1*bQ0ia4XbEoY3KS2YIzCYBg.png)

Nothing there. A quick `whoami` confirms we’re logged in as www-data. Let’s check around there.

![](https://miro.medium.com/v2/resize:fit:426/1*JvU9nkIOetaR1E7ueoG44w.png)

Bingpot.

Now, let’s escalate dem privileges, son.

Usually I’d run LinEnum or Linpeas or something at this stage, but the next task said to search files with SUID permission, so I just did that instead, along with searching for files owned by root.

![](https://miro.medium.com/v2/resize:fit:509/1*0rv1gFbwXAHpnnkFQRF5cQ.png)

Once you painstakingly scroll through the infinite `permission denied`’s, you’ll see `/usr/bin/python`. That’s weird. Let me just double check something, to make sure.. maybe my syntax was wrong?

![](https://miro.medium.com/v2/resize:fit:536/1*MWiT4VSw5uiELj2FOQv39w.png)

Yep, owned by root. Ladies and gentlemen, we have our target. Let’s head to gtfobins and look for something there.

![](https://miro.medium.com/v2/resize:fit:425/1*rQte2Ms_Vwg3eFXSM6E1ww.png)

This looks like it will do the trick.

![](https://miro.medium.com/v2/resize:fit:584/1*d6uZAuSCH-XhU021bgp1bg.png)

The trick has indeed been done.

So, how does it work?

Well, `/usr/bin/python` is owned by `root`, but it has the SUID permission, so when we run it as `www-data`, it _actually_ runs as `root` instead.

I won’t lie, I don’t know how to explain it any more than that. However, if you’d like to learn more, [this article](https://www.thegeekdiary.com/what-is-suid-sgid-and-sticky-bit/) by TheGeekDiary seems to make it pretty clear.

Anyway, that’s the box done. Not very difficult, but still really helpful for beginners.

Cheers for reading. Have a good one.

	This article was originally written by myself in 2021 on Medium.com