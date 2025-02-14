---
tags:
  - security
---
Today, I did [“RootMe” on TryHackMe](https://tryhackme.com/room/rrootme). This was a fun box. It was short and sweet - educational, but still fun.  
Let’s get into it:

# First Steps

Let’s start off with an nmap. Well, we have to, it’s part of the task.

![[nmap.bmp]]

Once nmap is finished, we see the open ports, along with the Apache version, and SSH on port 22.

![[nmap_results.bmp]]

After browsing to the site and seeing a static page, we can use our big brains and run a gobuster in dir mode. Or, we can read the next task, and figure it out that way. But pretending you thought of it all on your own is way better.

![[gobuster dir command.bmp]]

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

![[gobuster.out.bmp]]


gobuster.out

Panel? Weird. Let’s go there!

![[panel.bmp]]


Oooh, baby. Break out the red panties.

# The Fun Part

First, let’s get our webshell, and change the variables inside to match our IP and port we’re gonna listen on:

![[webshell.bmp]]

![[webshell2.bmp]]

How do I know that we can upload a webshell here, you might be asking?  
Well, the task says: _‘find a form to upload and get a reverse shell, and find the flag.’_

So, you know, just assuming.

Anyway, let’s upload!

![[panel error.bmp]]

Oh. Damn.  
I’m no polyglot, but I think I know what that error is.

So, let’s get to spoofin’.

First, I change the filename to shell.jpg.php, and... nada.

How about shell.php5?

![[panel success.bmp]]

Wow. That was easy.

Run `nc -lnvp 9001` before we visit the shell.php5 page and hooray!

![[netcat.bmp]]

Connected!

So, we have our shell now! Some people might go about upgrading it, with their `python -c 'import pty;pty.spawn("/bin/bash")'`and their stty -raw whatever. Not me. Mama raised a masochist.

Let’s have a little snoop around. First, let’s get user.txt, considering that’s our next task.

![[ls var.bmp]]

Nothing there. A quick `whoami` confirms we’re logged in as www-data. Let’s check around there.

![[catuser.bmp]]

Bingpot.

Now, let’s escalate dem privileges, son.

Usually I’d run LinEnum or Linpeas or something at this stage, but the next task said to search files with SUID permission, so I just did that instead, along with searching for files owned by root.

![[permissiondenied.bmp]]

Once you painstakingly scroll through the infinite `permission denied`’s, you’ll see `/usr/bin/python`. That’s weird. Let me just double check something, to make sure.. maybe my syntax was wrong?

![[pythonroot.bmp]]

Yep, owned by root. Ladies and gentlemen, we have our target. Let’s head to gtfobins and look for something there. _(Edit - Feb 2025: this command is literally burned into my brain)_

![[gtfobins.bmp]]

This looks like it will do the trick.

![[rooted.bmp]]

The trick has indeed been done.

So, how does it work?

Well, `/usr/bin/python` is owned by `root`, but it has the SUID permission, so when we run it as `www-data`, it _actually_ runs as `root` instead.

I won’t lie, I don’t know how to explain it any more than that. However, if you’d like to learn more, [this article](https://www.thegeekdiary.com/what-is-suid-sgid-and-sticky-bit/) by TheGeekDiary seems to make it pretty clear.

Anyway, that’s the box done. Not very difficult, but still really helpful for beginners.

Cheers for reading. Have a good one.

	This article was originally written by myself in 2021 on Medium.com