# Groxio LiveView Sept 2023
Groxio LiveView Course

## 1 Install these tools, plus Elixir, plus Phoenix. 

The tools you will need to install: 

- zoom with a working camera (We'll keep cameras on as much as possible)
- git (https://git-scm.com/downloads). 
- an editor that you are comfortable with. 
- a working PostgreSQL install

For the development dependencies, you'll need: 

- Elixir 1.15, with OTP 26. Make sure it's working: 

run the command: 

```
[course] ➔ iex
Erlang/OTP 26 [erts-14.0.2] [source] [64-bit] [smp:10:10] [ds:10:10:10] [async-threads:1] [jit]

Interactive Elixir (1.15.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> 
```

- Phoenix 1.7.x. This version of Phoenix is significantly different than previous ones.


Is Phoenix working? Make sure you can run this command: 

```
mix phx.new demo
(say yes to fetch dependencies and assets)
```

and make sure you can then create the database: 

```
cd demo
mix ecto.create
```

Don't save this for the last minute! There are a few dependencies that will give you trouble if you've never done this before and decide to wait. 


## 2. Clone this repository

1. Fork this repository to your github account. 

- Go to https://github.com/groxio-learning/liveview_9_20
- Click the `fork` button in the upper right corner
- Navigate to *your local version* (at something like git@github.com:your-github-user/liveview_9_20.git. )
- Copy the clone address to your clipboard. In the upper right, click `clone or download` then `copy to clipboard`

2. Clone your local version to your local machine. 

- Clone it. *REPLACE your-github-account with your account*:  

```
>  git clone <paste the url>
...clones repo...
cd liveview_9_20
```

- Verify your remote: 

```
$ git remote -v
> origin  https://github.com/your-user/liveview_9_20.git (fetch)
> origin  https://github.com/your-user/liveview_9_20.git (push)
```


- If there's no origin, set it. Make sure you *replace your-github-user*:

```
liveview_9_20> git remote add origin https://github.com/your-github-user/liveview_9_20.git
```

- Verify your remote: 

```
$ git remote -v
> origin  https://github.com/your-user/liveview_9_20.git (fetch)
> origin  https://github.com/your-user/liveview_9_20.git (push)
```

- Set the upstream to the Groxio repo:

```
liveview_9_20> git remote add upstream https://github.com/groxio-learning/liveview_9_20.git
```

- Verify the remotes: 

```
> origin  https://github.com/your-user/liveview_9_20.git (fetch)
> origin  https://github.com/your-user/liveview_9_20.git (push)
> upstream  https://github.com/groxio-learning/liveview_9_20.git (fetch)
> upstream  https://github.com/groxio-learning/liveview_9_20.git (push)
```

3. Now check out your setup. Send me a pull request: Edit the file "pull_requests.md" and add your name: 

- git pull upstream main
- Edit pull_requests.md

```
- other names
- Bruce Tate
- your name somewhere
- other names
```

- Commit the file and push

```
> git commit . -m "my commit"

...some happy success message...

> git push origin main

...some happy success message...
```

Now go to _your repo_ in your browser. Navigate to pull requests, and create the button to create a pull request. 

Your homework is done!
