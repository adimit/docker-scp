# docker-scp
Tiny image to allow copying things via scp. It's intended to be used for CI systems.

## Instructions

Instructions will vary according to the CI you're using.

### Generate your key

```
ssh-keygen -t ed25519 -f KEYNAME -C "This is some random comment"
```

Using ed25519 for more security. If you provide a password, you need to supply
it to ssh-agent in your CI, too.

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

Do preserve the comment, otherwise you're running the risk of dishonoring the 2+
hrs it took me to find out why using ssh-agent JUST. WOULDN'T. WORK.
