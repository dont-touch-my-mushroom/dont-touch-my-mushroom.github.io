# Source code for [Don't Touch My Mushroom's website](https://dont-tou.ch)
Please use branch `v2` for development. Branch `master` will be used for serving.

Every time there is a push to the branch `v2` a circleci job will build and deploy a new version (to master).

## Local development
There are two easy ways to develop locally, using docker or using nix.

### Using Docker
After installing Docker you can do:

```
docker-compose build
docker-compose up
```

The page will be served on http://localhost:4000
It will pick up changes in code and refresh the page.

#### Updating the gems file
You can attach a shell into the running docker container and do:
```
bundle update
```
## Circleci
We have a Circleci project set up to build and deploy a new page every time...
- The branch V2 has a push.
- Every night.

If you change anything on the gems and want to check if it will still build then you can try launching the circleci workflow locally by doing
```
circleci config process .circleci/config.yml > process.yml
circleci local execute -c process.yml --job build
```
It will probably error when trying to pull from git. That's fine, it doesn't
have the proper keys to do that. The important thing is that it builds the
jekyll page, which happens before.