# docker-scp
Tiny image to allow copying things via scp. It's intended to be used for CI systems.

## Instructions

Instructions will vary according to the CI you're using.

### Generate your key

**NOTE**: All of this happens on your host machine!

Given `$KEYNAME`, use the following to generate a key:

```
ssh-keygen -t ed25519 -f $KEYNAME -C "This is some random comment"
```

I'm using ed25519 for more security. Alternatively, use 3072 bit RSA if your
target server is old. If you provide a password, you need to supply it to
ssh-agent in your CI, too.

Copy it to the target server:

```
ssh-copy-id -i $KEYNAME user@yourhost
```

You may need to provide the `-f` option to `ssh-copy-id`. Try out if it worked:

```
ssh -i $KEYNAME user@yourhost
```

Take note of your `~/.ssh/known_hosts` for the host you're logging in to. You
will need to provide it as a host key for your CI, otherwise ssh gives an
interactive prompt and your CI script *will fail.*
Don't just switch off known hosts checks.

Chuck the known-host-key line, and the private key into CI variables.

### Gitlab-CI

After putting your credentials into CI variables (I recommend making them protected),
have your `script` look somewhat like this:

```
- eval $(ssh-agent -s)
# Gitlab inserts carriage returns into its variables because it's a piece of shit.
- ssh-add <(echo "${SSH_PRIVATE_KEY}" | tr -d '\r')
- 'echo "${SSH_HOST_KEY}" | tr -d "\r" > ~/.ssh/known_hosts'
- 'echo "${SSH_CONFIG}" | tr -d "\r" > ~/.ssh/config'
```

Last line is optional, use only if you have an ssh config you want to be using.

Do preserve the comment, otherwise you're running the risk of dishonoring the 2+
hrs it took me to find out why using ssh-agent JUST. WOULDN'T. WORK.
